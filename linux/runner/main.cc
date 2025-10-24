#include "word_buddylication.h"

int main(int argc, char** argv) {
  g_autoptr(MyApplication) app = word_buddylication_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
