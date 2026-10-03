#include "Matrix_2d.hpp"


Matrice::Matrice(int m, int n): m(m), n(n)
{
    mat.resize(m);
    for (int i = 0; i < m; i++)
    {
        mat[i].resize(n);
        fill(mat[i].begin(), mat[i].end(), 0);
    }
};

void Matrice::random_generation()
{
    for (int i = 0; i < m; i++)
    {
        for (int j = 0; j < n; j++)
        {
            mat[i][j] = (float)rand() / (float)RAND_MAX;
        }
    }
};

void Matrice::display_matrice() const
{
    for (int i = 0; i < m; i++)
    {
        for (int j = 0; j < n; j++)
        {
            cout << mat[i][j] << " " ;
        }
        cout << endl;
    }
    
};

int Matrice::get_hauteur() const {return (m);};
int Matrice::get_largeur() const {return (n);};

float Matrice::get_value(int x, int y) const
{
    if (x <  0 || x > m - 1 || y < 0 || y > n - 1)
    {
        cout << "Points are out of range" << endl;
        return (0);
    }
    return (mat[x][y]) ;
};

int Matrice::set_value(int x, int y, float value)
{
    if (x <  0 || x > m - 1 || y < 0 || y > n - 1)
    {
        cout << "Points are out of range" << endl;
        return (ERR);
    }
    mat[x][y] = value;
    return (OK);
};

static float get_sum(Matrice A, Matrice B, int i, int j, int n)
{
    float value;

    value = 0;
    for (int k = 0; k < n; k++)
    {
        //cout << "A: " << A.get_value(i, k) << " B: " << B.get_value(k, j) << endl;
        value += (A.get_value(i, k) * B.get_value(k, j));
    }
    return (value);
}

Matrice matrix_product(Matrice A, Matrice B)
{
 
    if(A.get_largeur() != B.get_hauteur())
        throw::invalid_argument("Matrix product is impossible" );
    Matrice C(A.get_hauteur(), B.get_largeur());
    assert(C.get_hauteur() == A.get_hauteur());
    assert(C.get_largeur() == B.get_largeur());
    for (int i = 0; i < C.get_hauteur(); i++)
    {
        for (int k = 0; k < C.get_largeur(); k++)
        {
            C.set_value(i, k, get_sum(A, B, i, k, C.get_largeur()));
        }
    }
    return (C);
}