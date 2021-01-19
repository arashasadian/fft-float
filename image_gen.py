with open('imag_gen.txt', 'w') as file:
    for i in range(0, 512):
            for j in range(0, 512):
                file.write(str(i *j) + "\t")
            file.write('\n') 
file.close()