# test_generator.py

def alu_sim(a, b, opcode):
    if opcode == 0b0000:  # ADD
        result = a + b
    elif opcode == 0b0001:  # SUB
        result = a - b
    elif opcode == 0b0010:  # AND
        result = a & b
    elif opcode == 0b0011:  # OR
        result = a | b
    elif opcode == 0b0100:  # XOR
        result = a ^ b
    elif opcode == 0b0101:  # SHL
        result = a << 1
    elif opcode == 0b0110:  # SHR
        result = a >> 1
    elif opcode == 0b0111:  # MUL
        result = a * b
    else:
        return None

    # Обрезаем до 8 бит
    result &= 0xFF

    # Флаги
    zero = int(result == 0)
    negative = int((result & 0x80) != 0)
    carry = int(result > 0xFF or result < 0)
    overflow = int(opcode in [0,1] and ((a ^ b ^ 0x80) & (a ^ result) & 0x80) != 0)

    return result, zero, negative, carry, overflow


def main():
    test_cases = [
        (10, 5, 0b0000),   # ADD
        (200, 100, 0b0000),
        (20, 50, 0b0001),  # SUB
        (0b10101010, 0b11001100, 0b0010),  # AND
        (0b10100000, 0b00001111, 0b0011),  # OR
        (0b11110000, 0b00001111, 0b0100),  # XOR
        (0b00001111, 0, 0b0101),  # SHL
        (0b11110000, 0, 0b0110),  # SHR
        (15, 15, 0b0111),  # MUL
    ]

    print(" A  | B  | OP  | Result | Z | N | C | O")
    print("----------------------------------------")
    for a, b, op in test_cases:
        result, z, n, c, o = alu_sim(a, b, op)
        print(f"{a:3} | {b:3} | {op:03b} | {result:6} | {z} | {n} | {c} | {o}")


if __name__ == "__main__":
    main()
