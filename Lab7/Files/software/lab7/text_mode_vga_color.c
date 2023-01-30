/*
 * text_mode_vga_color.c
 * Minimal driver for text mode VGA support
 * This is for Week 2, with color support
 *
 *  Created on: Oct 25, 2021
 *      Author: zuofu
 */

#include <system.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alt_types.h>
#include "text_mode_vga_color.h"

void textVGAColorClr()
{
	for (int i = 0; i<(ROWS*COLUMNS) * 2; i++)
	{
		vga_ctrl->VRAM[i] = 0x00;
	}
}

void textVGADrawColorText(char* str, int x, int y, alt_u8 background, alt_u8 foreground)
{
	int i = 0;
	while (str[i]!=0)
	{
		vga_ctrl->VRAM[(y*COLUMNS + x + i) * 2] = foreground << 4 | background;
		vga_ctrl->VRAM[(y*COLUMNS + x + i) * 2 + 1] = str[i];
		i++;
	}
}

//fill in this function to set the color palette starting at offset 0x0000 2000 (from base)
void setColorPalette (alt_u8 color, alt_u8 red, alt_u8 green, alt_u8 blue)
{
	alt_u32 red_32;
	alt_u32 green_32;
	alt_u32 blue_32;
	alt_u32 zero;
	alt_u32 zeroone;
	alt_u32 onezero;
	alt_u32 temp;

	red_32 = red;
	green_32 = green;
	blue_32 = blue;
	zero = 0x00000000;
	zeroone = 0x0000FFFF;
	onezero = 0xFFFF0000;
	temp = vga_ctrl->palette[color/2];

	if((color % 2) == 0){
		temp = temp & onezero;
		vga_ctrl->palette[color/2] = temp | (red_32 << 9) | (green_32 << 5) | (blue_32 << 1);
	}
	else if ((color % 2) == 1){
		temp = temp & zeroone;
		vga_ctrl->palette[color/2] = temp | (red_32 << 21) | (green_32 << 17) | (blue_32 << 13);
	}
}


void textVGAColorScreenSaver()
{
	//This is the function you call for your week 2 demo
	char color_string[80];
    int fg, bg, x, y;
	textVGAColorClr();
	//initialize palette
	for (int i = 0; i < 16; i++)
	{
		setColorPalette (i, colors[i].red, colors[i].green, colors[i].blue);
	}
	while (1)
	{
		fg = rand() % 16;
		bg = rand() % 16;
		while (fg == bg)
		{
			fg = rand() % 16;
			bg = rand() % 16;
		}
		sprintf(color_string, "Drawing %s text with %s background", colors[fg].name, colors[bg].name);
		x = rand() % (80-strlen(color_string));
		y = rand() % 30;
		textVGADrawColorText (color_string, x, y, bg, fg);
		usleep (100000);
	}
}
