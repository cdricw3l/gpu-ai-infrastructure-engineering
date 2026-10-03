

#include "Matrix_2d/Matrix_2d.hpp"


#define M_A 2
#define N_A 4
#define M_B 4
#define N_B 2

int main(void)
{

    #ifndef TEST
    Matrice A(M_A, N_A);
    Matrice B(M_B, N_B);
    
    cout << "Mat A:" << endl;
    A.random_generation();
    A.display_matrice();
    cout << endl;
    cout << "Mat B:" << endl;
    B.random_generation();
    B.display_matrice();

    cout << endl;

    try
    {
        Matrice C = matrix_product(A,B);

        for (int i = 0; i < C.get_hauteur(); i++)
        {
            for (int j = 0; j < C.get_largeur(); j++)
            {
                cout << C.get_value(i,j) << " " ;
            }
            cout << endl;
        }
    }
    catch(const std::exception& e)
    {
        std::cerr << e.what() << '\n';
    }
    
    return (0);
    #endif

}