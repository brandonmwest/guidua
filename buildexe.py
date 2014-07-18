#!/usr/bin/python
# -*- coding: iso-8859-1 -*-

# This file is part of Oidua.
#
# Oidua is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Copyright 2003	Sylvester Johansson 	(sylvestor@telia.com)
#			Mattias Päivärinta	(mpa99001@student.mdh.se)


# buildexe.py
# Use this script to build a oidua win32 exe-file.
# Needs the py2exe module (http://starship.python.net/crew/theller/py2exe/)
# Invoke with "buildexe.py py2exe --console -d [destination path]"
from distutils.core import setup
import py2exe

setup(name="oidua",
	scripts=["oidua.py"]
)
