from math import sin, cos, radians, degrees



if __name__ == "__main__":
    with open('sin_cos.txt', 'w') as file:
        for i in range(0, 361):
            file.write('s_rom({:d}) <= std_logic_vector(to_signed({:d},bitWidth));\n'.format(i, int(sin(radians(i))*255)))
        file.write('\n')
        for i in range(0, 361):
            file.write('c_rom({:d}) <= std_logic_vector(to_signed({:d},bitWidth));\n'.format(i, int(cos(radians(i))*255)))
    file.close()