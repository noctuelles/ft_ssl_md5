# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: plouvel <plouvel@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/06/05 11:17:26 by plouvel           #+#    #+#              #
#    Updated: 2024/09/24 16:07:21 by plouvel          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Paths

BUILD_PATH=build
TESTS_PATH=tests
INCLUDES_PATH=includes
SRCS_PATH=srcs
LIBFT_PATH=libft

DEPS_PATH=$(BUILD_PATH)/deps
OBJS_PATH=$(BUILD_PATH)/objs
TEST_RESULTS_PATH=$(BUILD_PATH)/test_results

UNITY_PATH=unity/src

PROJECT_INCLUDE=$(addprefix -I, $(INCLUDES_PATH) $(LIBFT_PATH)/includes ./)
UNITY_INCLUDE=$(addprefix -I, $(UNITY_PATH))
ALL_INCLUDE=$(PROJECT_INCLUDE) $(UNITY_INCLUDE)

# Sources

SRCS=main.c \
	 command.c \
	 md5.c \
	 sha256.c \
	 whirlpool.c \
	 wrapper.c \
	 utils.c \
	 opts/sha256.c \
	 opts/md5.c \
	 opts/whirlpool.c \

TESTS=test_utils.c \
      test_sha256.c

SRCS_TESTS:=$(addprefix $(TESTS_PATH)/, $(TESTS))

LIBFT_SRCS = $(wildcard $(LIBFT_PATH)/srcs/**/*.c)

# Output

OBJS=$(addprefix $(OBJS_PATH)/, $(SRCS:.c=.o))
TEST_RESULTS=$(addprefix $(TEST_RESULTS_PATH)/, $(TESTS:.c=.txt))
HEADS=$(addprefix -I, $(INCLUDES_DIR))

# Compilation

NAME=ft_ssl

CC=gcc
LINK=gcc
DEPENDS=gcc -MM -MG -MF

CFLAGS=-Wall -Werror -Wextra -Wpedantic -std=gnu11

DEBUG_FLAGS=-g3

# Misc

PASSED = `grep -s PASS $(TEST_RESULTS_PATH)/*.txt`
FAIL = `grep -s FAIL $(TEST_RESULTS_PATH)/*.txt`
IGNORE = `grep -s IGNORE $(TEST_RESULTS_PATH)/*.txt`

MKDIR=mkdir -p
RM=rm -rf

TARGET_EXTENSION=out

# Libs

LIBFT=$(LIBFT_PATH)/libft.a

# Rules

all: $(NAME)
clean:
	$(RM) $(BUILD_PATH)
fclean: clean
	$(RM) $(NAME)
re: fclean all

test: $(TEST_RESULTS_PATH) $(TEST_RESULTS)
	@echo "-----------------------\n\tIGNORED ⭕\n-----------------------"
	@echo "$(IGNORE)"
	@echo "-----------------------\n\tFAILURES ❌\n-----------------------"
	@echo "$(FAIL)"
	@echo "-----------------------\n\tPASSED ✅\n-----------------------"
	@echo "$(PASSED)"

#Rule to link the project
$(NAME): $(OBJS) $(LIBFT)
	$(LINK) -o $@ $^

# Rule to generate the test results
$(TEST_RESULTS_PATH)/%.txt: $(BUILD_PATH)/%.$(TARGET_EXTENSION)
	-./$< > $@ 2>&1

# Rule to link the test runner
$(BUILD_PATH)/test_%.$(TARGET_EXTENSION): $(OBJS_PATH)/test_%.o $(OBJS_PATH)/unity.o $(filter-out build/objs/main.o, $(OBJS)) $(LIBFT)
	$(LINK) -o $@ $^ 

# Rule to compile the files of the project
$(OBJS_PATH)/%.o:: $(SRCS_PATH)/%.c
	@$(MKDIR) $(dir $@)
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) $(PROJECT_INCLUDE) -c $< -o $@

# Rule to compile the Unity Framework
$(OBJS_PATH)/%.o:: $(UNITY_PATH)/%.c $(UNITY_PATH)/%.h | $(OBJS_PATH)
	$(CC) $(UNITY_INCLUDE) -c $< -o $@

# Rule to compile the tests of the project
$(OBJS_PATH)/%.o:: $(TESTS_PATH)/%.c | $(OBJS_PATH)
	$(CC) $(DEBUG_FLAGS) $(ALL_INCLUDE) -c $< -o $@

$(LIBFT):
	$(MAKE) -C $(LIBFT_PATH)

# Rules to create directories

$(OBJS_PATH):
	$(MKDIR) $@

$(TEST_RESULTS_PATH):
	$(MKDIR) $@

$(DEPS_PATH):
	$(MKDIR) $@

.PHONY: all clean fclean re
.PRECIOUS: $(BUILD_PATH)/test_%.$(TARGET_EXTENSION)
.PRECIOUS: $(OBJS_PATH)/%.o
.PRECIOUS: $(DEPS_PATH)/%.d
.PRECIOUS: $(TEST_RESULTS_PATH)/%.txt