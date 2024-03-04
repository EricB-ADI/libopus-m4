# Compiler and flags
CC := arm-none-eabi-gcc

# Directories
SRC_DIR := src
CELT_DIR := celt
SILK_DIR := silk
OBJ_DIR := obj
LIB_DIR := lib

CFLAGS := -Wall -Os
CFLAGS += -I $(SRC_DIR) -I $(CELT_DIR) -I $(SILK_DIR) 
CFLAGS += -I include -I . 
CFLAGS += -Isilk/fixed
CFLAGS += -mcpu=cortex-m4 -mthumb -mfloat-abi=hard
CFLAGS += -DUSE_ALLOCA -DHAVE_CONFIG_H


SRCS := $(wildcard $(SRC_DIR)/*.c) \
        $(wildcard $(CELT_DIR)/*.c) \
        $(wildcard $(SILK_DIR)/*.c)
OBJS := $(patsubst %.c,$(OBJ_DIR)/%.o,$(notdir $(SRCS)))
LIBRARY := $(LIB_DIR)/libopusm4.a

# Targets
all: $(LIBRARY)

$(LIBRARY): $(OBJS) | $(LIB_DIR)
	arm-none-eabi-ar rcs $@ $(OBJS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(CELT_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: $(SILK_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

clean:
	rm -rf $(OBJ_DIR) $(LIB_DIR)

.PHONY: all clean
