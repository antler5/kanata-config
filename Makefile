# SPDX-FileCopyrightText: 2024 antlers <antlers@illucid.net>
# 
# SPDX-License-Identifier: CC0-1.0

build: magic-strdy.kbd taipo.kbd neats.kbd

%.kbd: %.scm %.kbd.in
	./$<

magic-strdy.kbd: taipo.kbd
