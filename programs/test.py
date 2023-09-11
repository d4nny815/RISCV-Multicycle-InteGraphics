# RUN from root directory: python3 programs/make_mem_file.py
num_data_bits = 12       # number of bits for data
data_BITS = 2 ** num_data_bits - 1

num_addr_bits = 15

def main():
    mem = get_mem(num_addr_bits, len(bin(data_BITS)[2:]))
    write_mem_file(mem, './gpu/gpu_mem.mem')

def get_mem(addr_bits: int, data_bits) -> list:
    max_data = 2 ** data_bits - 1    
    return [(0xFFF) for _ in range(2 ** addr_bits)]

def write_mem_file(mem: list, outfile_name: str):
    with open(outfile_name, 'w') as f:
        for data in mem:
            f.write(hex(data)[2:] + '\n')

def draw_line(y_val, start_x, end_x):
    for i in range(end_x - start_x, 0, -1):
        x_addr = end_x - i
        addr = y_val << 8 | x_addr
        print(addr, (y_val, x_addr))
main()