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
# Copyright 2003	Sylvester Johansson	(sylvestor@telia.com)
#			Mattias Päivärinta	(mpa99001@student.mdh.se)

import sys,struct,re,string,os

__version__ = "0.15"

class OGG:
	def __init__(self,file):
		self.f = open(file,'rb')
		self.size = os.path.getsize(file)

		self.vbr = 1
		self.format = 0
		self.header = self.getheader()
		self.version = self.header[1]
		self.channels = self.header[2]
		self.samplerate = self.header[3]
		self.maxbitrate = self.header[4]
		self.nombitrate = self.header[5]
		self.minbitrate = self.header[6]
		self.type = "Ogg"
		#self.blocksize1 =    self.header[7]
		#self.blocksize2 =    self.header[8]

		self.fastmethod()

	def fastmethod(self):
		self.audiosamples = self.lastgranule()[-1]
		self.time = float(self.audiosamples) / self.samplerate
		self.bitrate = float(self.size * 8) * self.samplerate / self.audiosamples / 1000

	def exactmethod(self):
		#self.printheaderheader()
		self.streams = {}
		self.f.seek(0)
		while self.parsepage():
			pass

		#for k, v in self.streams.items():
		#    print "    %08X: %8d samples, %8d bytes" % (k, v[0], v[1])

		self.audiobits = self.streams.items()[0][1][1] * 8
		self.audiosamples = self.streams.items()[0][1][0]
		self.bitrate = long(self.audiobits) * self.samplerate / self.audiosamples
		self.bitrate = float(self.bitrate) / 1000
		self.time = float(self.audiosamples) / self.samplerate

	def parsepage(self):
		header = self.pageheader()
		segtable = self.segmenttable(header[7])
		size = self.pagesize(segtable)
		serial = header[4]
		if header[2] & 2:
			ident = self.f.read(size)
			self.streams[serial] = (0, 0, ident)
		else:
			data = self.streams[serial]
			if header[3] != data[0]:
				data = (header[3], data[1] + size, data[2])
				self.streams[serial] = data
			self.f.seek(size, 1)
		#self.printheader(header, size, segtable)
		return self.f.tell() != self.size

	def pageheader(self):
		headerformat = '<4s2BQ3IB'
		headersize = struct.calcsize(headerformat)
		return struct.unpack(headerformat, self.f.read(headersize))

	def segmenttable(self, segments):
		return list(struct.unpack("%dB" % segments, self.f.read(segments)))

	def pagesize(self, table):
		size = 0
		for seg in table:
			size =  size + seg
		return size

	def printheaderheader(self):
		print "V F          GRANULE  SERIAL# SEQ# CHECKSUM PSIZE SEGS"
		
	def printheader(self, header, size, segtable):
		if header[0] != "OggS":
			print "<Invalid header>"
			return
		print "%d %X %16X %08X %4d %08X %5d" % (header[1], header[2], header[3], header[4], header[5], header[6], size), segtable

	def getheader(self):
				# Setup header and sync stuff
		syncpattern = '\x01vorbis'
		overlap = len(syncpattern) - 1
		headerformat = '<x6sIBI3iB'
		headersize = struct.calcsize(headerformat)

		# Read first chunk
		self.f.seek(0)
		start = self.f.tell()
		chunk = self.f.read(1024 + overlap)

		# Do all file if we have to
		while len(chunk) > overlap:
			# Look for sync
			sync = chunk.find(syncpattern)
			if sync != -1:
				# Read the header
				self.f.seek(start + sync)
				return struct.unpack(headerformat, self.f.read(headersize))
			# Read next chunk
			start = start + 1024
			self.f.seek(start + overlap)
			chunk = chunk[-overlap:] + self.f.read(1024)

	def lastgranule(self):
		# The setup header and sync stuff
		syncpattern = 'OggS'
		overlap = len(syncpattern) - 1
		headerformat = '<4s2xl'
		headersize = struct.calcsize(headerformat)

		# Read last chunk
		self.f.seek(-1024, 2)
		start = self.f.tell()
		chunk = self.f.read(1024)

		# Do all file if we have to
		while len(chunk) > overlap:
			# Look for sync
			sync = chunk.find(syncpattern)
			if sync != -1:
				# Read the header
				self.f.seek(start + sync)
				return struct.unpack(headerformat, self.f.read(headersize))

			# Read next block
			start = start - 1024
			self.f.seek(start)
			chunk = self.f.read(1024) + chunk[:overlap]

	def profile(self):
		xiph = [80001,96001,112001,128003,160003,192003,224003,256006,320017,499821]
		gt3 = [80001,96001,112001,128005,180003,212003,244003,276006,340017,519821]

		try:
			return "-q"+str(xiph.index(self.nombitrate)+1)
		except:
			try:
				return "-q"+str(gt3.index(self.nombitrate)+1)
			except:
				return ""


class MP3:
	def __init__(self,file):
		self.f = open(file,'rb')

		self.brtable = [
			[ #MPEG2 & 2.5
			[0,  8, 16, 24, 32, 40, 48, 56, 64, 80, 96,112,128,144,160,0], #Layer III
			[0,  8, 16, 24, 32, 40, 48, 56, 64, 80, 96,112,128,144,160,0], #Layer II
			[0, 32, 48, 56, 64, 80, 96,112,128,144,160,176,192,224,256,0]  #Layer I
			],
			[ #MPEG1
			[0, 32, 40, 48, 56, 64, 80, 96,112,128,160,192,224,256,320,0], #Layer III
			[0, 32, 48, 56, 64, 80, 96,112,128,160,192,224,256,320,384,0], #Layer II
			[0, 32, 64, 96,128,160,192,224,256,288,320,352,384,416,448,0]  #Layer I
			]
			]
		self.fqtable = [
			[32000, 16000,  8000], #MPEG 2.5
			[    0,     0,     0], #reserved
			[22050, 24000, 16000], #MPEG 2  
			[44100, 48000, 32000]  #MPEG 1  
			]

		self.size = os.path.getsize(file)
		self.mp3header = self.getheader(self.id3offset())
		self.vbr = (bool(self.mp3header[1]=='Xing'))
		self.format = 1
		self.framesync = (self.mp3header[0]>>21 & 2047)
		self.versionindex = (self.mp3header[0]>>19 & 3)
		self.layerindex = (self.mp3header[0]>>17 & 3)
		self.protectionbit = (self.mp3header[0]>>16 & 1)
		self.bitrateindex = (self.mp3header[0]>>12 & 15)
		self.frequencyindex = (self.mp3header[0]>>10 & 3)
		self.paddingbit = (self.mp3header[0]>>9 & 1)
		self.privatebit = (self.mp3header[0]>>8 & 1)
		self.modeindex = (self.mp3header[0]>>6 & 3)
		self.modeextindex = (self.mp3header[0]>>4 & 3)
		self.copyrightbit = (self.mp3header[0]>>3 & 1)
		self.originalbit = (self.mp3header[0]>>2 & 1)
		self.emphasisindex = (self.mp3header[0] & 3)
		#self.framecount = (self.mp3header[3])
		self.framesize = (self.mp3header[4])
		self.frequency =  self.fqtable[self.versionindex][self.frequencyindex]
		
		if self.vbr:
			self.framecount = (self.mp3header[3])
			self.bitrate = ((float(self.framesize) / float(self.framecount)) * (float(self.frequency)) / self.modificator())
			
		else:
			self.bitrate = self.brtable[self.versionindex & 1][self.layerindex-1][self.bitrateindex]
			self.framecount = float(self.size) / (float(self.modificator()) * ((float(self.bitrate)) / float(self.frequency)))
		
		#self.time = (float(1 * 576 * (bool(self.versionindex>>1)+ 1)) / self.frequency) * self.framecount
		self.time = ((self.size * 8) / 1000) / self.bitrate
		self.type = "MP3"

	def id3offset(self):
		pattern = ">3s7Bx3s"
		
		self.f.seek(0)
		id3header = struct.unpack(pattern,self.f.read(struct.calcsize(pattern)))
		#print id3header[-1]
		if id3header[0] == "ID3" and id3header[-1] != "EOB":
			if id3header[1] == 2 or 3 or 4:
				return (((id3header[4] << 21) \
					| id3header[5] << 14) \
					| id3header[6] << 7) \
					| id3header[7] + 10 \
					+ (10 * id3header[3] & 3)
		return 0

	def getheader(self, offset = 0):
		# Setup header and sync stuff
		syncre = re.compile('\xff[\xe0-\xff]')
		overlap = 1
		pattern = '>l32x4s3l100xL9s2B8x2B'
		patternsize = struct.calcsize(pattern)

		# Read first block
		self.f.seek(offset)
		start = self.f.tell()
		chunk = self.f.read(1024 + overlap)

		# Do all file if we have to
		while len(chunk) > overlap:
			# Look for sync
			sync = syncre.search(chunk)
			while sync:
				# Read header
				self.f.seek(start + sync.start())
				header = struct.unpack(pattern,self.f.read(patternsize))
				
				# Return the header if it's valid
				if self.valid(header[0]):
					return header

				# How about next sync in this block?
				sync = syncre.search(chunk, sync.start() + 1)

			# Read next chunk
			start = start + 1024
			self.f.seek(start + overlap)
			chunk = chunk[-overlap:] + self.f.read(1024)

	def modificator(self):
		if self.layerindex == 3:
			return 12000
		else:
			return 144000

	def valid(self, header):
		return (((header>>21 & 2047) == 2047) and
				((header>>19 &  3) != 1) and
				((header>>17 &  3) != 0) and
				((header>>12 & 15) != 0) and
				((header>>12 & 15) != 15) and
				((header>>10 &  3) != 3) and
				((header     &  3) != 2))

	def profile(self):
		if self.mp3header[6][:4] == "LAME":
			try:
				version = string.atof(self.mp3header[6][4:8])
			except ValueError:
				return ""
			vbrmethod = self.mp3header[7] & 15
			lowpass = self.mp3header[8]
			ath = self.mp3header[9] & 15

			if version < 3.90:  #lame version
				if vbrmethod == 8:  #unknown
					if lowpass == 97 or lowpass == 98:
						if ath == 0:
							return "-r3mix"
			if version >= 3.90:  #lame version
				if vbrmethod == 3:  #vbr-old / vbr-rh
					if lowpass == 195 or lowpass == 196:
						if ath == 2:
							return "-ape"
					if lowpass == 190:
						if ath == 4:
							return "-aps"
				if vbrmethod == 4:  #vbr-mtrh
					if lowpass == 190:
						if ath == 4:
							return "-apfs"
					if lowpass == 195 or lowpass == 196:
						if ath == 2:
							return "-apfe"
						if ath == 3:
							return "-r3mix"
				if vbrmethod == 2:  #abr
					if lowpass == 206:
						if ath == 2:
							return "-api"
			return ""
		return ""


class MPC:
	def __init__(self,file):
		self.f = open(file,'rb')
		
		self.profiletable = [
			'NoProfile',
			'Unstable',
			'Unspec.',
			'Unspec.',
			'Unspec.',
			'BelowTel.',
			'BelowTel.',
			'Telephone',
			'Thumb',
			'Radio',
			'Standard',
			'Xtreme',
			'Insane',
			'Braindead',
			'AbvBrnded',
			'AbvBrnded'
			]
		self.fqtable = [44100,48000,37800,32000]
		self.size = os.path.getsize(file)
		self.vbr = 1
		self.format = 2
	#	self.profile = self.profiletable[self.getheader()[3]>>20 & 15]
		self.frequency = self.fqtable[self.getheader()[3]>>16 & 4]
		self.framecount= self.getheader()[2]
		self.bitrate = (float(self.size) / float(self.framecount)) * (float(self.frequency) / float(144000))
		self.time = (float(self.framecount) * 1.150 / float(44.1) + float(0.5))
		self.type = "MPC"
	
	def headerstart(self):
		self.f.seek(0)
		for x in range(self.size / 1024):
			buffer = self.f.read(1024)
			if re.search('MP+',buffer):
				return (x * 1024) + string.find(buffer,'MP+')

	def getheader(self):
		# Setup header and sync stuff
		syncre = re.compile('MP+')
		overlap = 1
		pattern = '3sb2i4h'
		patternsize = struct.calcsize(pattern)

		# Read first block
		self.f.seek(0)
		start = self.f.tell()
		chunk = self.f.read(1024 + overlap)

		# Do all file if we have to
		while len(chunk) > overlap:
			# Look for sync
			sync = syncre.search(chunk)
			while sync:
				# Read header
				self.f.seek(start + sync.start())
				header = struct.unpack(pattern,self.f.read(patternsize))
				
				# Return the header if it's valid
				if header[1]==7:
					return header

				# How about next sync in this block?
				sync = syncre.search(chunk, sync.start() + 1)
				
			# Read next chunk
			start = start + 1024
			self.f.seek(start + overlap)
			chunk = chunk[-overlap:] + self.f.read(1024)
 
	def profile(self):
		return self.profiletable[self.getheader()[3]>>20 & 15]


class FLAC:
	def __init__(self, file):
		self.format = 3
		self.vbr = 1

		self.f = open(file, 'rb')
		self.size = os.path.getsize(file)

		self.seekpoints = []  # [(sample number, byte offset, samples in frame), ...]
		self.comments = []    # vorbis comments
		self.streaminfo = None
			# 0 minimum blocksize
			# 1 maximum blocksize
			# 2 minimum framesize
			# 3 maximum framesize
			# 4 sample rate in Hz
			# 5 number of channels
			# 6 bits per sample
			# 7 total samples in stream
			# 8 MD5 sum of unencoded audio

		self.parse()
		self.samples = self.streaminfo[7]
		self.freq = self.streaminfo[4]
		self.time = self.samples / self.freq
		self.bitrate = self.size / self.time * 8 / 1000

		self.type = "FLAC"
		self.encoding = self.bitrate

	def parse(self):
		# STREAM
		if struct.unpack('>4s', self.f.read(4))[0] != 'fLaC':
			return

		last = 0
		while not last:
			# METADATA_BLOCK_HEADER
			data = struct.unpack('>I', self.f.read(4))[0]
			last, type, length = (data>>31, data>>24 & 0x7F, data & 0x00FFFFFF)

			if type == 0:
				# Stream Info
				data = struct.unpack('>3HI3Q', self.f.read(34))
				self.streaminfo = (data[0], data[1], (data[2] << 8) | (data[3] >> 24), data[3] & 0x00FFFFFF, data[4]>>44, (data[4]>>41 & 0x07) + 1, (data[4]>>36 & 0x1F) + 1, data[4] & 0x0000000FFFFFFFFF)
			elif type == 3:
				# Seektable
				for i in range(length/18):
					self.seekpoints.append(struct.unpack('2QH', self.f.read(18)))
			elif type == 4:
				# Vorbis Comment
				self.commentvendor, self.comments = self.readOggCommentHeader()
				#print "framing", framing
			else:
				# Padding or unknown
				self.f.seek(length, 1)

	def readLength(self):
		len = struct.unpack('<I', self.f.read(4))[0]
		if len >= self.size:
			raise ValueError
		return len

	def readString(self):
		len = self.readLength()
		return self.f.read(len)

	def readOggCommentHeader(self):
		list = []
		vendor = self.readString()
		for i in range(self.readLength()):
			list.append(self.readString())
		return vendor, list  #, struct.unpack('B', fd.read(1))

	def profile(self):
		return ""
