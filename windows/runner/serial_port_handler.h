#ifndef RUNNER_SERIAL_PORT_HANDLER_H_
#define RUNNER_SERIAL_PORT_HANDLER_H_

#include <flutter/binary_messenger.h>

// Register the serial port method channel handler
void RegisterSerialPortHandler(flutter::BinaryMessenger* messenger);

#endif  // RUNNER_SERIAL_PORT_HANDLER_H_

