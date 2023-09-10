# RUN from root directory: python3 programs/make_mem_file.py
num_data_bits = 12       # number of bits for data
data_BITS = 2 ** num_data_bits - 1

num_addr_bits = 15

def main():
    mem = get_mem(num_addr_bits, len(bin(data_BITS)[2:]))

    # print(hex(mem[0]), hex(mem[4095]), hex(mem[4096]), hex(mem[29999]))
    for addr, data in enumerate(mem):
        # my_str = f"addr: {addr}, data:{data}"
        # print(my_str)
        if data > data_BITS:
            print('data greater than 8 bits', data)
            return

    write_mem_file(mem, './gpu/gpu_mem.mem')


def get_mem(addr_bits: int, data_bits) -> list:
    max_data = 2 ** data_bits - 1    
    return [(i & max_data) for i in range(2 ** addr_bits)]


def write_mem_file(mem: list, outfile_name: str):
    with open(outfile_name, 'w') as f:
        for data in mem:
            f.write(hex(data)[2:] + '\n')

if __name__ == '__main__':
    main()


