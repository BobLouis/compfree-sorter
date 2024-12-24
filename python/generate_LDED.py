# 輸入 N 值
N = 16
print("casez(Temp_Reg)")

for i in range(N):
    print('    ', N, "\'b", end='', sep='')
    div = 0

    # print ?
    for j in range(N-i-1):
        print('?', end='')
        if div % 4 == 3 and div != N-1:
            print('_', end='')
        div += 1
    
    # print 1
    print(1, end='')
    if div % 4 == 3 and div != N-1:
        print('_', end='')
    div += 1

    # print 0
    for j in range(i):
        print(0, end='')
        if div % 4 == 3 and div != N-1:
            print('_', end='')
        div += 1
    
    print(": begin LE_addr <= ", end='')
    print(i,';\tTemp_Reg[', i, ']\t<= 0', sep='')

print('endcase\n')