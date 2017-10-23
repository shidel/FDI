# Messages used by pdTree v1 and FreeDOS tree 3.6
# Each line is limited to 159 characters unless MAXLINE is changed,
# but if possible should be limited to 79 per line, with a \n
# added to indicate go to next line, max 2 lines.
# The messages are split into sets,
# where each set corresponds to a given function in pdTree.
# Set 1, is for main and common strings.
# Many of the strings are used directly by printf,
# so when a %? appears, be sure any changes also include the %?
# where ? is a variable identifier and format.
# Note: only \\, \n, \r, \t are supported (and a single slash must use \\).
#
# common to many functions [Set 1]
1.1:\n
# main [Set 1] 
1.2:Список каталогов\n
# Must include %s for label 
1.3:Список каталогов для тома %s\n
# Must include %s for serial #  
1.4:Серийный номер тома: %s\n
1.5:Том не содержит подкаталогов.\n\n
# showUsage [Set 2] 
2.1:Графическое представление структуры диска или каталога.\n
# Each %c below will be replaced with proper switch/option
2.2:TREE [диск:][путь] [%c%c] [%c%c]\n
2.3:   %c%c   Отображать имена файлов в каждом каталоге.\n
2.4:   %c%c   Использовать ASCII вместо Extended ASCII.\n
# showInvalidUsage [Set 3] 
# Must include the %s for option given.
3.1:Некорректный ключ - %s\n
# The %c will be replaced with the primary switch (default is /)
3.2:Использовать TREE %c? для использования информации.\n
#showTooManyOptions
3.3:Слишком много параметров - %s\n
# showVersionInfo [Set 4] 
# also uses treeDescription, message 2.1
4.1:Написано для работы под FreeDOS,\n
4.2:командной строки Win32(c) и DOS с поддержкой LFN.\n
# Must include the %s for version string. 
4.3:Версия %s\n
4.4:Автор: Kenneth J. Davis\n
4.5:Дата:       Август/Сентябрь/Октябрь/Ноябрь, 2000; Январь, 2001\n
4.6:Контакты:    jeremyd@computer.org\n
4.7:Copyright (c): Public Domain [United States Definition]\n
#4.8 is only used when cats support is compiled in.
4.8:Uses Jim Hall's <jhall@freedos.org> Cats Library\n  Copyright (C) 1999,2000,2001 Jim Hall\n
#4.20 20-30 reserved for FreeDOS tree derived from Dave Dunfield's tree
#4.20:Copyright 1995 Dave Dunfield - Freely distributable.\n
4.20:Copyright 1995, 2000 Dave Dunfield - Freely distributable (2000 released GPL).\n
# showInvalidDrive [Set 5] 
5.1:Недопустимое имя диска\n
# showInvalidPath [Set 6] 
# Must include %s for the invalid path given. 
6.1:Некорректный путь - %s\n
# misc error conditions [Set 7]
# showBufferOverrun
# %u required to show what the buffer's current size is. 
7.1:Ошибка: Указанный путь к файлу превышает максимальный буфер = %u bytes\n
# showOutOfMemory
# %s required to display what directory we were processing when ran out of memory.
7.2:Недостаточно памяти в подкаталоге: %s\n
#
# parseArguments [Set 8] contains the Character[s] used for
#   argument processing.  Only the 1st character on a line is used.
#   Each argument is listed twice, the first is the uppercase version,
#   with the next entry being the lowercase version.
# Primary character used to determine option follows, default is '-'
8.1:/
# Secondary character used to determine option follows, default is '/'
8.2:-
# Indicates should show files
8.3:F
8.4:f
# Использовать только ASCII-кодировку
8.5:A
8.6:a
# Show Version information
8.7:V
8.8:v
# DOS only version, Shortnames only (disable LFN support)
8.9:S
8.10:s