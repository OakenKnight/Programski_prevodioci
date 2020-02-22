//OPIS: Numerički izraz
//RETURN: 25

int main() {
  int suma;
  int i;
	int j;
  suma = 0;
  for(i = 0; i < 5; i++)
		for(j = 0 ; j < 5 ; j++)
    	suma = suma + 1;

	return suma;
}
