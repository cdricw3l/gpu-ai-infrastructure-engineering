#ifndef MATRIX_2D_H
#define MATRIX_2D_H

#include <cstdio>
#include <iostream>
#include <string.h>
#include <assert.h>
#include <iomanip> 
#include <time.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <threads.h>
#include <vector>
#include <optional>

#define ERR 0
#define OK  1



using namespace std;

class Matrice
{
private:
    int m; // hauteur
    int n; // largeur
    std::vector<std::vector<float>> mat;

public:
    // Constructeur
    Matrice(int m, int n);

    // Méthodes
    void random_generation();
    void display_matrice() const;
    
    // Getters et Setters
    int get_hauteur() const;
    int get_largeur() const;
    float get_value(int x, int y) const;
    int set_value(int x, int y, float value);
};


Matrice matrix_product(Matrice A, Matrice B);

#endif