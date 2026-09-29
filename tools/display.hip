#include "../include/gpu_prog.h"

void	ft_putnbr_fd(int n, int fd)
{
	long	nb;
	char	c;

	if (fd < 0)
		return ;
	nb = n;
	if (nb < 0)
	{
		write(fd, "-", 1);
		nb = nb * -1;
	}
	if (nb >= 10)
		ft_putnbr_fd(nb / 10, fd);
	c = (nb % 10) + '0';
	write(fd, &c, 1);
}

static int	float_precision_ajustement(int n)
{
	if (n % 10 > 5)
		while (n % 10 != 0)
			n++;
	return (n);
}

void	put_float(float nb, int fd)
{
	int		ipart;
	int		f_adjusted;
	float	fpart;

	ipart = (int)nb * 100;
	if (ipart == 100)
	{
		ft_putnbr_fd(ipart, fd);
		return ;
	}
	fpart = (nb - (float)ipart) * 10;
	if (ipart == 0 && fpart == 0)
	{
		ft_putnbr_fd(0, fd);
		return ;
	}
	f_adjusted = float_precision_ajustement((int)(fpart * 10000)) / 10;
	ft_putnbr_fd((f_adjusted / 1000) % 10, fd);
	ft_putnbr_fd((f_adjusted / 100) % 10, fd);
	write(fd, ".", 1);
	ft_putnbr_fd((f_adjusted / 10) % 10, fd);
	ft_putnbr_fd((f_adjusted) % 10, fd);
}

void display_arr(float *arr_a, float *arr_b, float *arr_result)
{
    long i;

    for (i = 0; i < N; i++)
    {
        assert(arr_result[i] = arr_a[i] * arr_b[i]);
        if (arr_a)
            std::cout << "idx: " << i << std::fixed << std::setprecision(3) << " arr_a: " << arr_a[i];
        if (arr_b)
            std::cout << std::fixed << std::setprecision(3) << " arr_b: " << arr_b[i];
        if (arr_result)
            std::cout << std::fixed << std::setprecision(3) << " result: " << arr_result[i] << std::endl;
        else
            std::cout << std::endl;
    }
}


int display_result(float *arr_a, float *arr_b, float *arr_result)
{
    int i;
    int fd;
    
    fd = open("result_ouput.txt",  O_WRONLY | O_APPEND | O_CREAT, 0644);
    if (fd < 0)
    {
        perror("file descriptor error");
        return(ERR);
    }
    for (i = 0; i < OUT_MODE_RESULT; i++)
    {
        std::cout << "idx: " << i << std::fixed << std::setprecision(3) << " arr_a: " << arr_a[i];
        std::cout << std::fixed << std::setprecision(3) << " arr_b: " << arr_b[i];
        std::cout << std::fixed << std::setprecision(3) << " result: " << arr_result[i] << std::endl;
        std::cout << std::endl;
    }
    return (OK);
}