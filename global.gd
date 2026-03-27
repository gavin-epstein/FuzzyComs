extends Node

static var code
static var playerType #options: Ship, Station
static var level = 1 #1: intro, 2: cutscene+ panel, 3: thanksforplaying
static var otherCode
static var version = "A"
signal levelChanged
