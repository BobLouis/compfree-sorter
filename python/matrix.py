def hex_to_binary(hex_str, bit_length):
    # 將十六進制轉換成整數，並根據位數將其轉換成二進制字串
    value = int(hex_str, 16)
    # 若為有號數，處理負數
    if value >= 2 ** (bit_length - 1):
        value -= 2 ** bit_length
    binary_str = format(value if value >= 0 else (1 << bit_length) + value, f'0{bit_length}b')
    return binary_str

def read_hex_from_file(file_path, bit_length):
    # 讀取 dat 檔案的所有十六進制數
    with open(file_path, 'r') as f:
        hex_numbers = f.read().splitlines()
    return [hex_to_binary(hex_num.strip(), bit_length) for hex_num in hex_numbers]

def transpose_bits(binary_list):
    # 轉置二進制字串，將每一位對應的位元進行轉置
    transposed = [''.join(bits) for bits in zip(*binary_list)]
    return transposed

# 設定檔案路徑和bit長度
file_path = 'dat/n8_N16/pattern0.dat'  # 替換成你的 dat 檔案路徑
bit_length = 16  # 這裡假設每個16進制數是16位元

# 讀取並轉換十六進制數為二進制
binary_list = read_hex_from_file(file_path, bit_length)

# 將位元進行轉置
transposed_bits = transpose_bits(binary_list)

# 印出結果
print("Original Binary Numbers:")
for binary in binary_list:
    print(binary)

print("\nTransposed Bits:")
for bits in transposed_bits:
    print(bits)
