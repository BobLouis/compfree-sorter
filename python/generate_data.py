import numpy as np
import matplotlib.pyplot as plt
import os

# 生成數據並繪製分佈
def gen_data(N, n, distribution, sigma, signed=False):
    if distribution == 'uniform':
        if signed:
            # 生成有號數據，範圍從 -2^(n-1) 到 2^(n-1) - 1
            min_val = -2**(n-1)
            max_val = 2**(n-1) - 1
            data = np.random.uniform(min_val, max_val + 1, N).astype(np.int64)
        else:
            # 生成無號數據，範圍從 0 到 2^n - 1
            data = np.random.uniform(0, 2**n, N).astype(np.uint64)
        plot_distribution(n, data, 'uniform', signed=signed)
    elif distribution == 'gaussian':
        if signed:
            mean = 0
            stddev = sigma * 2**(n-1)
            data = np.random.normal(loc=mean, scale=stddev, size=N)
            min_val = -2**(n-1)
            max_val = 2**(n-1) - 1
            data = np.clip(data, min_val, max_val).astype(np.int64)
        else:
            mean = 2**(n-1)
            stddev = sigma * mean
            data = np.random.normal(loc=mean, scale=stddev, size=N)
            min_val = 0
            max_val = 2**n - 1
            data = np.clip(data, min_val, max_val).astype(np.uint64)
        plot_distribution(n, data, 'gaussian', signed=signed)
    
    return data

# 保存數據為十六進位格式
def save_data_as_hex(data, version, N, n, directory, prefix='pattern', signed=False):
    # 動態建立資料夾名稱，依照 N 和 n 組合
    sub_directory = f"n{n}_N{N}"
    full_directory = os.path.join(directory, sub_directory)

    # 確保目標目錄存在
    if not os.path.exists(full_directory):
        os.makedirs(full_directory)
    
    # 檔案名稱只包含 version，例如 pattern1.dat, golden1.dat
    filename = f'{prefix}{version}.dat'
    
    # 組合完整的檔案路徑
    filepath = os.path.join(full_directory, filename)

    # 計算需要的十六進制數字的長度
    hex_length = (n + 3) // 4  # 每4个位元对应1个十六进制位
    # 以十六進制格式保存數據，並根據位寬填充不足位數
    with open(filepath, 'w') as f:
        for value in data:
            if signed:
                # 將有號數據轉換為無號兩補數表示形式
                value = value & ((1 << n) - 1)
            f.write(f"{value:0{hex_length}X}\n")  # 確保填充到 hex_length 位
    print(f"Data written to {filepath} in hex format with {n}-bit width")

# 使用 Python 內建的 sorted() 進行排序，可升冪或降冪
def sort_data(data, reverse=True):
    return sorted(data, reverse=reverse)

# 繪製數據的分佈圖
def plot_distribution(n, data, distribution, signed=False):
    plt.figure(figsize=(10, 6))
    plt.hist(data, bins=50, alpha=0.7, color='blue', edgecolor='black')
    plt.title(f'Data Distribution: {distribution.capitalize()}')
    if signed:
        plt.xlim(-2**(n-1), 2**(n-1) - 1)
    else:
        plt.xlim(0, 2**n - 1)
    plt.xlabel('Data Value')
    plt.ylabel('Frequency')
    plt.grid(True)
    plt.show()


N = 256  # data elements
n = 8  # bit-width
distribution = 'gaussian'  # 分布情況 ('uniform' 或 'gaussian')
directory = 'D:/Paper/1004_WorstCase_Proposed/dat/'

sort_order = True  # True 表示降冪，False 表示升冪
signed = True  # True 表示有號數據，False 表示無號數據

data = gen_data(N, n, 'uniform', 0, signed=signed)
save_data_as_hex(data, 0, N, n, directory, prefix='pattern', signed=signed)
sorted_data = sort_data(data, reverse=sort_order)
save_data_as_hex(sorted_data, 0, N, n, directory, prefix='golden', signed=signed)

for i in range(1, 4):
    sigma_value = i / 10
    data = gen_data(N, n, distribution, sigma_value, signed=signed)
    save_data_as_hex(data, i, N, n, directory, prefix='pattern', signed=signed)
    sorted_data = sort_data(data, reverse=sort_order)
    save_data_as_hex(sorted_data, i, N, n, directory, prefix='golden', signed=signed)
