library id3;

import 'dart:io';
import 'dart:convert';

import 'const.dart';
/*
id3v2

while (end) {
      final len = _frameSizeOf(sBytes.sublist(offset + 4, offset + 8));
      final fr = sBytes.sublist(offset);

      final m = ff.getFrame(fr).decode(sBytes.sublist(offset));

      tags[m?.key] = m?.value;

      offset = offset + _headerLength + len;

      if(m == null){
        //when the first tag is null we go to false - we don't expect any more tags
        end = false;
      }else {
        end = offset < size;
      }
    }

    return tags;
  }
 */
class MP3Instance {
  List<int> mp3Bytes;
  Map<String, dynamic> metaTags;

  /// Member Functions
  MP3Instance(String mp3File) {
    var file = File(mp3File);
    mp3Bytes = file.readAsBytesSync();
    metaTags = {};
  }

  bool parseTagsSync() {
    var _tag;
    _tag = mp3Bytes.sublist(0, 3);

    if (latin1.decode(_tag) == 'ID3') {
      var major_v = mp3Bytes[3];
      var revision_v = mp3Bytes[4];
      var flag = mp3Bytes[5];

      var unsync = (0x40 & flag != 0);
      var extended = (0x20 & flag != 0);
      var experimental = (0x10 & flag != 0);

      metaTags['Version'] = 'v2.$major_v.$revision_v';

      if (extended) {
        print('Extended id3v2 tags are not supported yet!');
      } else if (unsync) {
        print('Unsync id3v2 tags are not supported yet!');
      } else if (experimental) {
        print('Experimental id3v2 tag');
      }

      List<int> frameHeader;
      List<int> frameName;
      List<int> frameContent;
      int frameSize;
      var cb = 10;

      while (true) {
        frameHeader = mp3Bytes.sublist(cb, cb + 10);
        frameName = frameHeader.sublist(0, 4);

        var exp = RegExp(r'[A-Z0-9]+');
        if (latin1.decode(frameName) !=
            exp.stringMatch(latin1.decode(frameName))) {
          break;
        }

        frameSize = parseSize(frameHeader.sublist(4, 8));
        //erst offset 10 (von gesamten daten)
        //dann offset headerlength (10) + 1
        frameContent = mp3Bytes.sublist(cb + 10, cb + 10 + frameSize);

        if (FRAMESv2_3[latin1.decode(frameName)] == FRAMESv2_3['APIC']) {
          var apic = {
            'mime': '',
            'textEncoding': frameContent[0].toString(),
            'picType': '',
            'description': '',
            'base64': ''
          };

          var offset = 0;

          for (var i = 1; i < frameContent.length; i++) {
            if (frameContent[i] == 0) {
              apic['mime'] = latin1.decode(frameContent.sublist(1, i));
              offset = i;
              break;
            }
          }
          apic['picType'] = frameContent[++offset].toString();

          for (var i = offset + 1; i < frameContent.length; i++) {
            if (frameContent[i] == 0) {
              apic['description'] =
                  latin1.decode(frameContent.sublist(offset + 1, i));
              offset = i;
              break;
            }
          }


          var imgData = getData(frameContent.sublist(1));

          apic['base64'] = base64.encode(imgData);
          metaTags['APIC'] = apic;
        } else {
          var tag =
              FRAMESv2_3[latin1.decode(frameName)] ?? latin1.decode(frameName);
          metaTags[tag] = latin1.decode(cleanFrame(frameContent));
        }

        cb += 10 + frameSize;
      }

      return true;
    }

    var _header = mp3Bytes.sublist(mp3Bytes.length - 128, mp3Bytes.length);
    _tag = _header.sublist(0, 3);

    if (latin1.decode(_tag).toLowerCase() == 'tag') {
      metaTags['Version'] = '1.0';

      var _title = _header.sublist(3, 33);
      var _artist = _header.sublist(33, 63);
      var _album = _header.sublist(63, 93);
      var _year = _header.sublist(93, 97);
      var _comment = _header.sublist(97, 127);
      var _genre = _header[127];

      metaTags['Title'] = latin1.decode(_title).trim();
      metaTags['Artist'] = latin1.decode(_artist).trim();
      metaTags['Album'] = latin1.decode(_album).trim();
      metaTags['Year'] = latin1.decode(_year).trim();
      metaTags['Comment'] = latin1.decode(_comment).trim();
      metaTags['Genre'] = GENREv1[_genre];

      return true;
    }

    return false;
  }

  List<int> getData(List<int> data){

    final iterator = data.iterator;
    var buff = <int>[];


    var cont = 0;

    while (iterator.moveNext() && cont < 4) {
      final crnt = iterator.current;
      if (crnt == 0x00 && cont < 3) {
        if (cont == 1 && buff.isNotEmpty) {
         // attachedPicture.imageTypeCode = buff[0];
          cont++;
        //  attachedPicture.description = enc.decode(buff.sublist(1));
        } else {
        //  attachedPicture.mime = enc.decode(buff);
        }
        buff = [];
        cont++;
        continue;
      }
      buff.add(crnt);
    }

    return buff;
  }

  Map<String, dynamic> getMetaTags() {
    return metaTags;
  }
}

int parseSize(List<int> block) {
  assert(block.length == 4);

  var len = block[0] << 24;//21
  len += block[1] << 16;//14
  len += block[2] << 8;//7
  len += block[3];

  return len;
}

List<int> cleanFrame(List<int> bytes) {
  if (bytes.length > 3) {
    return bytes.sublist(3);
  } else {
    return bytes;
  }
}

List<int> removeZeros(List<int> bytes) {
  return bytes.where((i) => i != 0).toList();
}