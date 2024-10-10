#include "lib/tester.h"

static bool initialized = false;

extern void adainit(void);
extern void init(size_t tester_instruction_mem_size,
                 uint8_t *tester_instruction_mem);
extern void get_state(struct state *state);
extern void set_state(struct state *state);
extern int step(void);

static void myinit(size_t tester_instruction_mem_size,
                   uint8_t *tester_instruction_mem) {
  if (!initialized) {
    initialized = true;
    adainit();
  }

  init(tester_instruction_mem_size, tester_instruction_mem);
}

struct tester_operations myops = {
    .init = myinit,
    .set_state = set_state,
    .get_state = get_state,
    .step = step,
};
