#include "serial_port_handler.h"

#include <windows.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <string>
#include <vector>
#include <sstream>
#include <thread>
#include <future>

// Handle serial port reading on Windows
class SerialPortHandler {
 public:
  static void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
    
    const std::string& method_name = method_call.method_name();
    const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());

    if (method_name == "readLine") {
      if (!arguments) {
        result->Error("INVALID_ARGS", "Arguments required");
        return;
      }

      std::string port = "COM34";
      int baudRate = 9600;
      int timeoutMs = 20000;

      auto port_it = arguments->find(flutter::EncodableValue("port"));
      if (port_it != arguments->end()) {
        port = std::get<std::string>(port_it->second);
      }

      auto baud_it = arguments->find(flutter::EncodableValue("baudRate"));
      if (baud_it != arguments->end()) {
        baudRate = std::get<int>(baud_it->second);
      }

      auto timeout_it = arguments->find(flutter::EncodableValue("timeoutMs"));
      if (timeout_it != arguments->end()) {
        timeoutMs = std::get<int>(timeout_it->second);
      }

      // Run serial port reading on background thread to avoid blocking UI
      std::thread([port, baudRate, timeoutMs, result = std::move(result)]() {
        // Convert port name to wide string (e.g., "COM34" -> L"\\\\.\\COM34")
        std::wstring portName = L"\\\\.\\" + std::wstring(port.begin(), port.end());

        HANDLE hSerial = CreateFileW(
            portName.c_str(),
            GENERIC_READ,
            0,
            NULL,
            OPEN_EXISTING,
            0,
            NULL);

        if (hSerial == INVALID_HANDLE_VALUE) {
          result->Error("PORT_ERROR", "Cannot open port");
          return;
        }

        // Configure serial port
        DCB dcbSerialParams = {0};
        dcbSerialParams.DCBlength = sizeof(dcbSerialParams);
        if (!GetCommState(hSerial, &dcbSerialParams)) {
          CloseHandle(hSerial);
          result->Error("CONFIG_ERROR", "Cannot get comm state");
          return;
        }

        dcbSerialParams.BaudRate = baudRate;
        dcbSerialParams.ByteSize = 8;
        dcbSerialParams.StopBits = ONESTOPBIT;
        dcbSerialParams.Parity = NOPARITY;

        if (!SetCommState(hSerial, &dcbSerialParams)) {
          CloseHandle(hSerial);
          result->Error("CONFIG_ERROR", "Cannot set comm state");
          return;
        }

        // Set timeouts
        COMMTIMEOUTS timeouts = {0};
        timeouts.ReadIntervalTimeout = 50;
        timeouts.ReadTotalTimeoutConstant = timeoutMs;
        timeouts.ReadTotalTimeoutMultiplier = 10;
        timeouts.WriteTotalTimeoutConstant = 50;
        timeouts.WriteTotalTimeoutMultiplier = 10;

        if (!SetCommTimeouts(hSerial, &timeouts)) {
          CloseHandle(hSerial);
          result->Error("TIMEOUT_ERROR", "Cannot set timeouts");
          return;
        }

        // Read until CR (\r) or timeout
        std::string line;
        char buffer[1];
        DWORD bytesRead;
        bool foundCR = false;

        DWORD startTime = GetTickCount();
        while (!foundCR && (GetTickCount() - startTime) < (DWORD)timeoutMs) {
          if (ReadFile(hSerial, buffer, 1, &bytesRead, NULL)) {
            if (bytesRead > 0) {
              if (buffer[0] == '\r') {
                foundCR = true;
              } else if (buffer[0] != '\n') {
                line += buffer[0];
              }
            }
          } else {
            DWORD error = GetLastError();
            if (error != ERROR_IO_PENDING && error != ERROR_NO_DATA) {
              break;
            }
          }
          // Small sleep to yield CPU
          Sleep(10);
        }

        CloseHandle(hSerial);

        if (foundCR && !line.empty()) {
          result->Success(flutter::EncodableValue(line));
        } else {
          result->Success(flutter::EncodableValue());  // null/empty on timeout
        }
      }).detach();  // Detach thread - Flutter will handle result callback thread-safety

    } else if (method_name == "getAvailablePorts") {
      std::vector<std::string> ports;
      
      // Enumerate COM ports (COM1-COM256)
      for (int i = 1; i <= 256; i++) {
        std::wstring portName = L"COM" + std::to_wstring(i);
        HANDLE hPort = CreateFileW(
            (L"\\\\.\\" + portName).c_str(),
            GENERIC_READ | GENERIC_WRITE,
            0,
            NULL,
            OPEN_EXISTING,
            0,
            NULL);

        if (hPort != INVALID_HANDLE_VALUE) {
          ports.push_back("COM" + std::to_string(i));
          CloseHandle(hPort);
        }
      }

      std::vector<flutter::EncodableValue> portList;
      for (const auto& port : ports) {
        portList.push_back(flutter::EncodableValue(port));
      }
      result->Success(flutter::EncodableValue(portList));

    } else {
      result->NotImplemented();
    }
  }
};

// Static channel to keep it alive
static std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> g_channel;

// Register method channel handler
void RegisterSerialPortHandler(flutter::BinaryMessenger* messenger) {
  g_channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      messenger, "com.quanly/serial_port",
      &flutter::StandardMethodCodec::GetInstance());

  g_channel->SetMethodCallHandler(
      [](const flutter::MethodCall<flutter::EncodableValue>& call,
         std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
        SerialPortHandler::HandleMethodCall(call, std::move(result));
      });
}

