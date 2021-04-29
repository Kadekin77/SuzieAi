unit suzie;

interface

const
  version = '2.0';

procedure parce(s: string);
function load(text: string): string;
procedure say(s: string);
function a(s: string): boolean;
procedure d(s: string);
procedure rootcmdparce;
function cmd(s: string): string;
procedure faqparce;
procedure init;
function answ(s: string): string;
function sino(s: string): string;

var
  name, curusr: string;
  canspeak: boolean;

implementation

uses sysutils, shellapi, FMX.Forms, VCL.Forms, Unit1, masks, classes, utils;

var
  last, tparce: string;
  said, debug: boolean;
  faq, words, sins: tstringlist;

function answ(s: string): string;
var
  i, k: Integer;
  t: string;
begin
  i := 1;
  while s[i] <> '' do
  begin
    if s[i] = '{' then
    begin
      k := i;
      while s[k] <> '}' do
        inc(k);
      t := cmd(copy(s, i + 1, k - i - 1));
      delete(s, i, k - i + 1);
      insert(t, s, i);
      dec(i);
    end;
    inc(i);
  end;
  result := s;
end;

procedure d(s: string);
begin
  if debug then
    form1.output('[' + s + ']');
end;

function sino(s: string): string;
begin
  if sins.Values[s] <> '' then
    result := sins.Values[s]
  else
    result := s;
end;

procedure init;
var
  path: string;
begin
  canspeak := true;
  path := extractfilepath(application.ExeName) + '\brains\';
  faq := tstringlist.Create;
  words := tstringlist.Create;
  words.LoadFromFile(path + 'phrases.txt');
  faq.LoadFromFile(path + 'faq.txt');
  sins := tstringlist.Create;
  sins.LoadFromFile(path + 'sinonims.txt');
  curusr := 'dysha';
  name := sino(curusr);
  say('Инициализация завершена');
  say('Моя база знаний на данный момент позволяет разпознавать ' +
    inttostr(faq.Count * sins.Count) + ' выражений и выводить ' +
    inttostr(faq.Count * words.Count));
end;

function cmd(s: string): string; // {@kill} {&yes} {%time}
var
  t: string;
begin
  t := copy(s, 2, length(s));
  if s[1] = '@' then
  begin
    if t = 'dbg1' then
      debug := true;
    if t = 'dbg0' then
      debug := false;
    if t = 'init' then
      init;
    if t = 'term' then
      application.Terminate;
  end;
  if s[1] = '%' then
  begin
    // if t = '' then result :=
    if t = 'cname' then
      result := curusr;
    if t = 'name' then
      result := name;
    if t = 'ver' then
      result := version;
  end;
  if s[1] = '&' then
    result := load(t);
end;

function load(text: string): string;
var
  i: Integer;
begin
  result := words.Values[text];
  if result = '' then
  begin
    i := 1;
    while words.Values[text + inttostr(i)] <> '' do
      inc(i);
    if i > 1 then
      result := words.Values[text + inttostr(random(i - 1) + 1)];
  end;
  if result = '' then
    result := 'Внутренняя ошибка';
end;

procedure faqparce;
var
  i: Integer;
begin
  for i := 0 to faq.Count - 1 do
  begin
    if a(faq.Names[i]) then
      say(answ(faq.ValueFromIndex[i]));
  end;
end;

procedure rootcmdparce;
begin
  //
end;

function a(s: string): boolean;
begin
  if matchesmask(tparce, s) then
    result := true
  else
    result := false;
end;

procedure parce(s: string);
var
  p, o, i, t, i1: Integer;
  t1: string;
  str: tstringlist;
begin
  str := tstringlist.Create;
  said := false;
  s := ansilowercase(s);
  trim(s);
  stringtowords(s, str);
  s := '';
  for i := 0 to str.Count - 1 do
    s := s + sino(str[i]) + ' ';
  delete(s, length(s), 1);
  s := answ(s);
  d(s);
  tparce := s;
  rootcmdparce;
  faqparce;
end;

procedure say(s: string);
var
  i: Integer;
begin
  if canspeak then
  begin
    said := true;
    // if curname <> '' then
    // s := curname + ', ' + s;
    form1.output(s);
  end;
end;

end.
