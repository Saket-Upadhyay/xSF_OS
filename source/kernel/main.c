// MIT License

// Copyright (c) 2021 Saket Upadhyay

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include "print.h"

//This function is called by main64.asm after zeroing out important segments.
void main_kernel()
{
    print_clear();
    set_print_color(COLOR_GREEN, COLOR_BLACK);
    print_string("Hello, xSFOS kernel is successfully booted.\nWe are printing directly to video memory : ");
    set_print_color(COLOR_YELLOW, COLOR_BLACK);
    print_string("0xb8000\n\n");
    set_print_color(COLOR_WHITE, COLOR_BLACK);
    print_string("Till this stage in development, we've implemented -\n[x] Base Code\n[x] Boot loader\n[x] Enable longmode (64bit)\n[x] Paging and Stack\n[x] Call subroutine from C code\n[x] Print String\n[x] Control Foreground and Background color.,\n\nIn next stage we will try to do basic data manipulation and ultimately we will\nmake a ");
    set_print_color(COLOR_RED, COLOR_BLACK);
    print_string("calculator");
    set_print_color(COLOR_WHITE, COLOR_BLACK);
    print_string(" here.");
    set_print_color(COLOR_LIGHT_BLUE, COLOR_DARK_GRAY);
    print_string("\n\n=> Project xSFOS\n=> (https://github.com/Saket-Upadhyay/xSF_OS)");
}
