//OPIS: for ispisuje i
//RETURN: 12
int main(){
	int i;
	int j;
	int l;
	int suma;
	l=0;
	j=0;
	i=0;
	suma=0;	

	iterate i step 1 to 5:
	{
		iterate j step 1 to 3:
			suma = suma + 1;
		l = l + 1;
	}
	return suma+l;
}
