#!/usr/bin/python -t
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
# Copyright 2003  Sylvester Johansson  (sylvestor@telia.com)
#                 Mattias Päivärinta   (mpa99001@student.mdh.se)

"""Usage:  oidua.py [options] <basedir> ...

Options:
  -B, --bg COLOR      Set HTML background color
  -D, --date          Display datestamp header
      --debug         Output debug trace to stderr
  -e, --exclude DIR   Exclude dir from search
  -f, --file FILE     Write output to FILE
  -g, --global-sort   Sort folders globally
  -h, --help          Display this message
  -H, --html          HTML output
  -i, --ignore-case   Case-insensitive directory sorting
  -p, --preset FLAGS  Guess preset of specified formats. FLAGS is a
                      string made from the following key letters:
                      mp[3], [o]gg, [m]pc, [f]lac, [a]ll
  -q, --quiet         Omit progress indication
  -S, --stats         Display statistics results
  -t, --time          Display elapsed time footer
  -T, --text COLOR    Set HTML text color
  -V, --version       Display version
  -W, --width N       Set output width to N characters (Default: 80)
"""

__version__ = "0.15"

import sys, string, re, os, time, signal, getopt, audiotype, glob


class Data:
	def __init__(self):
		self.BadFiles = []
		self.Base = 0
		self.PathStack = []
		self.Progress = 0
		self.Start = 0
		self.Size = {
			"Total": 0.0,
			"FLAC": 0.0,
			"OGG": 0.0,
			"MP3": 0.0,
			"MPC": 0.0}
		self.TimeTotal = 0.0
		#self.TimeFLAC = 0.0
		#self.TimeOGG = 0.0
		#self.TimeMP3 = 0.0
		#self.TimeMPC = 0.0


class Settings:
	def __init__(self):
		# always output to __stderr__ from inside Settings
		try:
			# factory defaults
			self.BGColor = "white"
			self.CaseInsensitiveSort = 0
			self.Debug = 0
			self.DispVersion = 0
			self.DispTime = 0
			self.DispHelp = 0
			self.DispDate = 0
			self.DispResult = 0
			self.GlobalSort = 0
			self.ExcludePaths = []
			self.Folders = []
			self.OutputFormat = "plain"
			self.OutStream = sys.stdout
			self.Profile = []
			self.Quiet = 0
			self.TextColor = "black"
			self.Width = 80

			sys.stdout = sys.__stderr__
			# parse the command line
			self.parse()
		except SystemExit:
			raise SystemExit
		except:
			unexpected_error("Settings.parse")

		# redirect stdout to the correct stream
		sys.stdout = self.OutStream

		# options overriding eachother
		if (self.OutStream == sys.__stdout__
		   or self.Debug):
			self.Quiet = 1

	def parse(self):
		try:
			self.opts, basedirs = getopt.getopt(sys.argv[1:],
				"B:T:p:e:W:f:DhHiqStVg",
				["bg=",
				"text=",
				"preset=",
				"exclude=",
				"width=",
				"file=",
				"date",
				"debug",
				"help",
				"ignore-case",
				"quiet",
				"stats",
				"time",
				"version",
				"global-sort"])
		except getopt.GetoptError:
			print __doc__
			sys.exit(2)

		# parse option pairs
		for o, a in self.opts:
			if o in ("-B", "--bg"): self.BGColor = a
			elif o in ("-D", "--date"): self.DispDate = 1
			elif o in ("--debug",): self.Debug = 1
			elif o in ("-e", "--exclude"): self.exclude_dir(a)
			elif o in ("-f", "--file"): self.set_outstream(a)
			elif o in ("-H", "--html"): self.OutputFormat = "HTML"
			elif o in ("-h", "--help"): self.DispHelp = 1
			elif o in ("-i", "--ignore-case"): self.CaseInsensitiveSort = 1
			elif o in ("-p", "--preset"): self.set_preset(a)
			elif o in ("-q", "--quiet"): self.Quiet = 1
			elif o in ("-S", "--stats"): self.DispResult = 1
			elif o in ("-T", "--text"): self.TextColor = a
			elif o in ("-t", "--time"): self.DispTime = 1
			elif o in ("-V", "--version"): self.DispVersion = 1
			elif o in ("-W", "--width"): self.set_width(a)
			elif o in ("-g", "--global-sort"): self.GlobalSort = 1

		# sort basedirs
		temp = []
		for x in basedirs:
			for y in glob.glob(x):
				if os.path.isdir(y):
					temp.append(y)
		basedirs = temp
		if self.GlobalSort:
			offsets = []
			
			for dir in basedirs:
				offsets.append( (os.path.basename(dir), os.path.abspath(dir)) )

			if self.CaseInsensitiveSort:
				offsets.sort(lambda x,y : icmp(x[0], y[0]))
			else:
				offsets.sort()
			for pair in offsets:
				self.add_basedir(pair[1])
		else:
			self.Folders = basedirs

		# reject "no operation" configurations
		if (not self.Folders
		   and not self.DispVersion
		   and not self.DispHelp):
			print "No folders to process."
			print "Type 'oidua.py -h' for more information."
			sys.exit(2)

	def set_outstream(self, file):
		try:
			self.OutStream = open(file, 'w')
		except IOError, (errno, errstr):
			print "I/O Error(%s): %s" % (errno, errstr)
			print "Cannot open '%s' for writing" % file
			sys.exit(2)

	def add_basedir(self, dir):
		if os.path.isdir(dir):
			self.Folders.append(dir)
		else:
			print "There is no directory '%s'" % dir
			sys.exit(2)

	def exclude_dir(self, dir):
		if dir[-1] == os.sep:
			dir = dir[:-1]
		if os.path.isdir(dir):
			self.ExcludePaths.append(dir)
		else:
			print "There is no directory '%s'" % dir
			sys.exit(2)

	def set_width(self, width):
		try:
			self.Width = string.atoi(width)
		except ValueError:
			print width, "is not an integer"
			sys.exit(2)

	def toggle_profiles(self, profiles):
		for p in profiles:
			self.toggle_profile(p)

	def toggle_profile(self, profile):
		self.Profile = set_toggle(self.Profile, profile)

	def set_preset(self, formatstring):
		self.Profile = []
		for x in formatstring:
			if x == "a": self.toggle_profiles(["FLAC", "Ogg", "MP3", "MPC"])
			elif x == "o": self.toggle_profile("Ogg")
			elif x == "3": self.toggle_profile("MP3")
			elif x == "m": self.toggle_profile("MPC")
			elif x == "f": self.toggle_profile("FLAC")


def icmp(a, b):
	return cmp(string.lower(a), string.lower(b))


def main():
	if config.DispHelp:
		print >> sys.stderr, __doc__
		return 0
	if config.OutputFormat == "HTML":
		htmlheader()
	if config.DispDate == 1:
		headers("date")
	globals.Start = time.clock()
	if config.Folders:
		headers("header")
		for x in config.Folders:
			globals.Base = string.count(x[:-1], os.sep)
			grab(x)
			smash(x)
	if globals.BadFiles and not config.Debug:
		print ""
		print "Audiotype failed on the following files:"
		for i in globals.BadFiles:
			print i

	globals.ElapsedTime = time.clock() - globals.Start
	if config.DispTime:
		print ""
		print "Generation time:     %8.2f s" % globals.ElapsedTime
	if config.DispResult:                # changed in 0.15
		statistics = [
			["Ogg", globals.Size["OGG"]],
			["MP3", globals.Size["MP3"]],
			["MPC", globals.Size["MPC"]],
			["FLAC", globals.Size["FLAC"]]]
		line = "+-----------------------+-----------+"

		print ""
		print line
		print "| Format    Amount (Mb) | Ratio (%) |"
		print line
		for x in statistics:
			if x[1]:
				print "| %-8s %12.2f | %9.2f |" % (
					x[0],
					x[1] / (1024 * 1024),
					x[1] * 100 / globals.Size["Total"])
		print line
		totalMegs = globals.Size["Total"] / (1024 * 1024)
		print "| Total %10.2f Mb   |" % totalMegs
		print "| Speed %10.2f Mb/s |" % (totalMegs / globals.ElapsedTime)
		print line[:25]
	if config.DispVersion:
		print ""
		print "oidua version:    ", __version__
		print "audiotype version:", audiotype.__version__
	if config.OutputFormat == "HTML":
		htmlfooter()


def htmlheader():
	# XXX Should we _always_ use this charset?
	print """<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Music List</title>
<!-- Generated by oidua %s -->
<!-- http://legolas.mdh.se/~dal99mpa/oidua.html -->
<style type="text/css"><!--
body { color: %s; background: %s; }" 
//-->
</style>
</head>
<body>
<pre>""" % (__version__, config.TextColor, config.BGColor)


def progress():
	if config.Quiet: return
	globals.Progress = (globals.Progress + 1) % 7
	print >> sys.stderr, config.Quiet, 
	print >> sys.stderr, "\r%.1f Mb processed %c" % (
		globals.Size["Total"] / (1024 * 1024),
		" .o0O0o"[globals.Progress]),


def end_progress():
	if sys.stdout == sys.__stdout__ or config.Quiet: return
	print >> sys.stderr, ""
	

def htmlfooter():
	print"</pre>"
	#print "<p><a href=\"http://validator.w3.org/check/referer\">"
	#print "<img src=\"http://www.w3.org/Icons/valid-html401\" alt=\"Valid HTML 4.01!\" height=\"31\" width=\"88\"></a></p>"
	print"</body></html>"


def set_toggle(set, element):
	if element in set:
		pos = set.index(element)
		return set[:pos] + set[pos+1:]
	else:
		set.append(element)
		return set


def average(values):
	tot = 0
	for val in values:
		tot += val
	return tot / len(values)


def vbrchecker(vbrlist):
	if len(vbrlist) == 1:
		return "CV"[vbrlist[0]]
	else:
		return "~"


def depth_of(path):
	return string.count(path, os.sep) - globals.Base


def put_post(folder, size, type, encoding, depth=0):
	folder = ("   "*depth + folder)[:config.Width - 30]
	print "%-*s|%7s | %-4s | %s" % (
		config.Width - 30, folder, size, type, encoding)


def headers(token):
	if token == "header":  #top header
		put_post(" Album/Artist", "Mb", "Type", "Encoding")
		print "="*(config.Width-30) + '+========+======+==========='
	elif token == "date":  #date
		timestring = time.strftime("%a %b %d %H:%M:%S %Y",
		                           time.localtime())
		print "%*s" % (
			config.Width-2,
			timestring)


def set_insert(set, element):
	try:
		set.index(element)
	except ValueError:
		set.append(element)


def fileformat(formats):
	if len(formats) >= 2:
		return "misc"
	else:
		return ["Ogg", "MP3", "MPC", "FLAC"][formats[0]]


def has_suffix(str, suffix):
	return suffix == string.lower(str[-len(suffix):])


def outputter(path, albumsize, bitrates, presets, vbrtuple, filetypes):
	if bitrates:
		size = "%.1f" % (albumsize / (1024*1024.0))
		type = fileformat(filetypes)
		# All files have same profile, and profiling is on for type.
		# Notice profiling is always of for 'mixed'.
		if len(presets) == 1 and type in config.Profile:
			encoding = presets[0]
		else:
			encoding = "%4d %s" % (average(bitrates), vbrchecker(vbrtuple))
	else:
		size = ""
		type = ""
		encoding = ""
	put_post(os.path.split(path)[-1], size, type, encoding, depth_of(path))


def debug(msg):
	if config.Debug: print >> sys.stderr, "?? " + msg


def grab(folder):
	debug("enter grab(%s)" % folder)
	bitrates = []
	format = []
	vbrtuple = []
	presets = []
	files = []
	for x in os.listdir(folder):
		if os.path.isfile(os.path.join(folder, x)):
			files.append(x)
	files.sort()

	size_mp3 = 0
	size_mpc = 0
	size_ogg = 0
	size_flac = 0
	for x in files:
		progress()
		try:
			filename = os.path.join(folder,x)
			if has_suffix(x, ".mp3"):
				file = audiotype.MP3(filename)
				size_mp3 += file.size
			elif has_suffix(x, ".mpc"):
				file = audiotype.MPC(filename)
				size_mpc += file.size
			elif has_suffix(x, ".ogg"):
				file = audiotype.OGG(filename)
				size_ogg += file.size
			elif has_suffix(x, ".flac"):
				file = audiotype.FLAC(filename)
				size_flac += file.size
			else:
				continue
		except KeyboardInterrupt:
			raise KeyboardInterrupt
		except:
			if config.Debug:
				print "Auditype failed for:", filename
			else:
				globals.BadFiles.append(filename)

		bitrates.append(file.bitrate)
		set_insert(format, file.format)
		set_insert(vbrtuple, file.vbr)
		if file.type in config.Profile:
			profile = file.profile()
			if profile:
				set_insert(presets, profile)

	size_all = size_mp3 + size_mpc + size_ogg + size_flac
	globals.Size["MP3"] += size_mp3
	globals.Size["MPC"] += size_mpc
	globals.Size["OGG"] += size_ogg
	globals.Size["FLAC"] += size_flac
	globals.Size["Total"] += size_all

	if size_all:
		# print delayed output
		for path in globals.PathStack:
			put_post(os.path.split(path)[-1], "", "", "", depth_of(path))
		globals.PathStack = []

		outputter(folder, size_all, bitrates, presets, vbrtuple, format)
	else:
		# delay output
		globals.PathStack.append(folder)
	debug("exit  grab(%s)" % folder)


def subdirectories(dir):
	subdirs = []
	for file in os.listdir(dir):
		path = os.path.join(dir, file)
		if (os.path.isdir(path)
		   and os.access(path, os.R_OK)):
			subdirs.append(path)
	return subdirs


def unexpected_error(func):
	print "Unexpected error in %s: %s" % (func, sys.exc_info()[0])
	sys.exit(1)


def smash(dir):
	debug("enter smash(%s)" % dir)
	subdirs = subdirectories(dir)
	if config.CaseInsensitiveSort:
		subdirs.sort(icmp)
	else:
		subdirs.sort()
	for subdir in subdirs:
		try:
			config.ExcludePaths.index(subdir)
		except ValueError:
			try:
				grab(subdir)
				smash(subdir)
			except KeyboardInterrupt:
				raise KeyboardInterrupt
			except:
				unexpected_error("smash")
	# forget this directory unless its already printed
	if globals.PathStack:
		globals.PathStack = globals.PathStack[:-1]
	debug("exit  smash(%s)" % dir)


if __name__ == "__main__":
	config = Settings()
	globals = Data()
	try:
		main()
	except KeyboardInterrupt:
		print >> sys.stderr, "Aborted by user"
		sys.exit(1)
	except:
		unexpected_error("main")
	end_progress()
