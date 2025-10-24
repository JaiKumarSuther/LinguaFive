#ifndef FLUTTER_word_buddyLICATION_H_
#define FLUTTER_word_buddyLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(MyApplication, word_buddylication, MY, APPLICATION,
                     GtkApplication)

/**
 * word_buddylication_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #MyApplication.
 */
MyApplication* word_buddylication_new();

#endif  // FLUTTER_word_buddyLICATION_H_
