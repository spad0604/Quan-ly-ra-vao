import serial
import time

# Cấu hình cổng COM
port = "COM34"
baudrate = 9600

try:
    # Khởi tạo kết nối
    ser = serial.Serial(port, baudrate, timeout=1)
    print(f"Đang kết nối tới {port}...")
    
    # Chờ một chút để kết nối ổn định
    time.sleep(2)

    while True:
        if ser.in_waiting > 0:
            # Đọc raw bytes trước
            raw_bytes = ser.readline()
            
            # In raw bytes dạng hex để xem chính xác
            hex_str = ' '.join([f'{b:02x}' for b in raw_bytes])
            print(f"\n=== RAW BYTES (hex): {hex_str}")
            
            # Decode thành string
            line = raw_bytes.decode('utf-8')
            
            # In repr() để thấy các ký tự đặc biệt (\r, \n, v.v.)
            print(f"=== RAW STRING (repr): {repr(line)}")
            
            # Kiểm tra các ký tự xuống dòng
            has_cr = '\r' in line
            has_lf = '\n' in line
            print(f"=== Có CR (\\r): {has_cr}, Có LF (\\n): {has_lf}")
            
            # In dữ liệu sau khi strip (như code cũ)
            line_clean = line.rstrip()
            print(f"=== Dữ liệu sau rstrip(): {line_clean}")
            print(f"=== Độ dài raw: {len(line)}, sau rstrip: {len(line_clean)}")
            print("=" * 60)

except serial.SerialException as e:
    print(f"Lỗi: Không thể mở cổng {port}. Hãy kiểm tra xem thiết bị đã cắm chưa hoặc có ứng dụng nào khác đang dùng cổng này không.")
except KeyboardInterrupt:
    print("\nĐã dừng chương trình.")
finally:
    # Đóng cổng khi kết thúc
    if 'ser' in locals() and ser.is_open:
        ser.close()
        print("Đã đóng cổng COM.")