extends Node2D

const CTYPE_TEXTURES =  [
	preload("res://sptites/red.tres"),
	preload("res://sptites/blue.tres"),
	preload("res://sptites/green.tres"),
	preload("res://sptites/yellow.tres"),
]
enum ColorType {
	RED,
	GREEN,
	BLUE,
	YELLOW,
}

var MATCH_COUNT = 4
