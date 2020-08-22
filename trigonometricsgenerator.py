from math import sin, cos, radians, degrees



if __name__ == "__main__":
    with open('sin_cos.txt', 'w') as file:
        for i in range(0, 361):
            file.write('s_rom({:d}) <= to_float({:f});\n'.format(i, (sin(radians(i)))))
        file.write('\n')
        for i in range(0, 361):
            file.write('c_rom({:d}) <= to_float({:f});\n'.format(i, (cos(radians(i)))))
    file.close()