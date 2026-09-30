CC=hipcc
NAME=gpu_work
VAL_LOG = val.log
CFLAGS=-Werror -Wall -Wextra -g \
       -std=c++23 \
	   -pthread \
       --offload-arch=gfx1100

SRCS=	main.hip \
		gpu/gpu.hip \
		cpu/cpu.hip \
		tools/time.hip \
		tools/display.hip \
		memory/memory_clean_check.hip \
		memory/init_1D_arr.hip

SRCS_OBJS=${SRCS:.hip=.o}

%.o: %.hip
	$(CC) $(CFLAGS) -c $< -o $@

$(NAME): $(SRCS_OBJS)
	$(CC) $(CFLAGS) $(SRCS_OBJS) -o $(NAME)

MODE=cpu

run: $(NAME)
	./$(NAME) $(MODE)

val: $(NAME)
	valgrind --leak-check=full --show-leak-kinds=all --log-file=$(VAL_LOG) ./$(NAME)

clean:
	rm -f $(SRCS_OBJS) $(VAL_LOG)

cmakeclean:
	find . -name build -type d -exec rm -rf {} \;

fclean: clean cmakeclean
	rm -f $(NAME)

re: fclean $(NAME)

COM=cmake_tutorial
git: fclean
	git add .
	git commit -m $(COM)
	git push

.PHONY: clean fclean re val run cmakeclean