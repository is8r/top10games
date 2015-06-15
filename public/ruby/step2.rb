require 'json'

# --------------------------------------------------
# setting

is_debug = false

if is_debug
  file_input = 'dist/results_mini.json'
  file_output = 'dist/rank_mini.json'
else
  file_input = 'dist/results.json'
  file_output = 'dist/rank.json'
end

# --------------------------------------------------
# function

def format_width (s)
  s.tr!("０-９", "0-9")
  s.tr!("Ａ-Ｚ", "A-Z")
  s.tr!("ａ-ｚ", "a-z")
  s.gsub!("　", " ")
  s.gsub!("（", "(")
  s.gsub!("）", ")")
end

def format_number (s)
  s.gsub!(/XⅣ$/, "14" )
  s.gsub!(/XIII$/, "13" )
  s.gsub!(/XII$/, "12" )
  s.gsub!(/XI$/, "11" )
  s.gsub!(/Ⅸ$/, "9" )
  s.gsub!(/X$/, "10" )
  s.gsub!(/Ⅷ$/, "8" )
  s.gsub!(/Ⅶ$/, "7" )
  s.gsub!(/VII$/, "7" )
  s.gsub!(/Ⅵ$/, "6" )
  s.gsub!(/Ⅴ$/, "5" )
  s.gsub!(/Ⅳ$/, "4" )
  s.gsub!(/Ⅲ$/, "3" )
  s.gsub!(/III$/, "3" )
  s.gsub!(/Ⅱ$/, "2" )
  s.gsub!(/Ⅰ$/, "1" )
  s.gsub!(/II$/, "2" )
  s.gsub!(/3rd$/, "3" )
  s.gsub!(/2nd$/, "2" )
  s.gsub!(/2ndG$/, "2G" )
  s.gsub!(/\s\d/, '\2' )
end

# --------------------------------------------------
# excute

file = File.read(file_input)
source = JSON.parse(file)

texts = ''
source.each do |i|
  unless i['text'].include?("RT @")
    texts += i['text']
  end
end

texts.gsub!("＃", "#")
texts.gsub!("#自分の人生においてトップ10に入るゲームをあげてけ", "")
ar = texts.split("\n")

re = []
ar.each do |i|

  # フォーマットを統一したい
  format_width(i)
  format_number(i)
  i.gsub!(/^・/, "")
  i.gsub!(/^ /, "")
  i.gsub!("(SFC)", "")
  i.gsub!("(FC)", "")
  i.gsub!("(GB)", "")
  i.gsub!("(GC)", "")

  # 例外処理
  i.gsub!(/^FFTA/, "ファイナルファンタジータクティクスアドバンス")
  i.gsub!(/^FFT/, "ファイナルファンタジータクティクス")
  i.gsub!(/^FF/i, "ファイナルファンタジー")
  i.gsub!(/^ドラクエ/, "ドラゴンクエスト")
  i.gsub!(/^DQ/i, "ドラゴンクエスト")

  i.gsub!("スト2", "ストリートファイター2" )
  i.gsub!(/^スパロボ/, "スーパーロボット大戦")
  i.gsub!(/^モンハン/, "モンスターハンター")
  i.gsub!(/^MOTHER/i, "マザー")
  i.gsub!(/^skyrim/i, "スカイリム")
  i.gsub!(/^beatmania/i, "ビートマニア")
  i.gsub!(/^Minecraft/i, "マインクラフト")
  i.gsub!(/^GTAV/i, "GTA5")
  i.gsub!(/^MGS/i, "メタルギアソリッド")
  i.gsub!(/^MHP/i, "モンスターハンターポータブル")
  i.gsub!(/^PSO/i, "ファンタシースターオンライン")
  i.gsub!(/^COD/i, "Call of Duty")
  i.gsub!("Duty:", "Duty ")
  i.gsub!(/^KOF/i, "ザ・キング・オブ・ファイターズ")
  i.gsub!(/^TO/i, "テイルズオブ")
  i.gsub!(/^KH/i, "キングダムハーツ")

  i.gsub!(/^　/, "")
  i.gsub!(/^\s/, "")
  i.gsub!(/^ /, "")

  if i.include?("@")
    next
  elsif i.include?("やってみた")
    next
  elsif i.include?("越えられない壁")
    next
  elsif i.include?("順不同")
    next
  elsif i.empty?
    next
  else
    re.push i
  end
end

# create hash
hash = {}
re.each do |i|
  if hash.has_key?(i)
    hash[i] += 1
  else
    hash[i] = 1
  end
end

# 5票以下を削除
hash.delete_if {|key, val| val < 5 }

# sort
result = hash.sort_by{|key,val| -val}

# array2hash
h = Hash[*result.flatten]

File.write(file_output, h.to_json)