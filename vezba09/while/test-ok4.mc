//OPIS: Numerički izraz
//RETURN: 20

int main() {
  int suma;
  int i;
	int j;
	int k;
  suma = 0;
  for(i = 0; i < 5; i++)
		for(j = 0 ; j < 2 ; j++)
			for(k = 0 ; k < 2 ; k++)
    		suma = suma + 1;

	return suma;
}
