def main():
    mem = get_mem(15, 8)
    write_mem_file(mem, 'gpu_mem.mem')


def get_mem(addr_bits: int, data_bits) -> list:
    max_data = 2 ** data_bits - 1    
    return [(i & max_data) for i in range(2 ** addr_bits)]

def write_mem_file(mem: list, file_name: str):
    with open(file_name, 'w') as f:
        for data in mem:
            f.write(hex(data)[2:] + '\n')

if __name__ == '__main__':
    main()


