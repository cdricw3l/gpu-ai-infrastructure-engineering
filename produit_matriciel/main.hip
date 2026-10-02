#include <cstdio>
#include <iostream>
#include <string.h>
#include <assert.h>
#include <iomanip> 
//#include <hip/hip_runtime.h>
#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <threads.h>
#include <vector>
#include <optional>

using namespace std;

class Matrice
{
    int m;
    int n;
    vector<vector<float>> mat;

    public:
        /* 
            m = hauteur 
            n = largeur
        */

        Matrice(int m, int n): m(m), n(n)
        {
    
            for (size_t i = 0; i < m; i++)
            {
                vector<float> a;

                for (size_t j = 0; j < n; j++)
                {
                    a.push_back((float)rand() / (float)RAND_MAX);
                }
                this->mat.push_back(a);
            }
            cout << "Matice creation succes" << endl << endl;
        };
        void display_matrice() const
        {
            for (size_t i = 0; i < m; i++)
            {
                for (size_t j = 0; j < n; j++)
                {
                    cout << mat[i][j] << " " ;
                }
                cout << endl;
            }
            
        }
        int get_hauteur(){return (m);};
        int get_largeur(){return (n);};
        float get_value(int x, int y)
        {
            if (x <  0 || x > m - 1 || y < 0 || y > n - 1)
            {
                cout << "Points are out of range" << endl;
                return (0);
            }
            return (mat[x][y]) ;
        }
};

float get_sum(Matrice A, Matrice B, int i, int j, int n)
{
    float value;

    value = 0;
    for (size_t k = 0; k < n; k++)
    {
        //cout << "A: " << A.get_value(i, k) << " B: " << B.get_value(k, j) << endl;
        value += (A.get_value(i, k) * B.get_value(k, j));
    }
    return (value);
}

vector<vector<float>> matrix_product(Matrice A, Matrice B)
{
    vector<vector<float>> mat;
    int m;
    int n;

    if(A.get_largeur() != B.get_hauteur())
    {
        cout << "Matrix product is impossible" << endl;
        return (mat);
    }
    m = A.get_hauteur();
    n = B.get_largeur();
    for (size_t i = 0; i < m; i++)
    {
        vector<float> ligne;

        for (size_t k = 0; k < n; k++)
        {
            ligne.push_back(get_sum(A, B, i, k, A.get_largeur()));
        }
        mat.push_back(ligne);
    }
    
    return (mat);

}

int main(void)
{

    Matrice A(4, 5);
    Matrice B(5, 4);
    
    cout << "Mat A:" << endl;
    A.display_matrice();
    cout << endl;
    cout << "Mat B:" << endl;
    B.display_matrice();
    cout << endl;

    vector<vector<float>> new_mat = matrix_product(A,B);
    for (size_t i = 0; i < 40; i++)
    {
        for (size_t j = 0; j < 40; j++)
        {
            cout << new_mat[i][j] << " " ;
        }
        cout << endl;
    }
    

    return (0);
}