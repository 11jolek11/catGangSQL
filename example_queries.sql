-- SIMPLE QUERIES
SELECT nazwa_funkcji, count(*) FROM koty GROUP BY nazwa_funkcji;

SELECT pseudo FROM koty WHERE funkcja = 'szef';

SELECT count(*) FROM myszy;

-- SIMPLE QUERIES WITH JOIN
SELECT koty.pseudo, bandy.teren FROM koty JOIN bandy ON koty.nr_bandy = bandy.nr_bandy;

SELECT incydenty.pseudo_kota, lapowki_wrogow.lapowki FROM incydenty ?left? JOIN lapowki_wrogow;

SELECT bandy.nazwa FROM bandy
MINUS
SELECT bandy.nazwa FROM bandy JOIN koty USING(nr_bandy)
WHERE koty.nazwa_funkcji = 'medyk'
GROUP BY bandy.nazwa;

-- QUERIES WITH SUBQUERIES

-- Znajdź koty których wrogowie jako przekupstwo biorą szynkę;

SELECT incydenty.pseudo_kota
FROM incydenty
WHERE lapowka IS IN
(SELECT lapowki_wrogow.imie 
FROM lapowki_wrogow
WHERE lapowki_wrogow.lapowka = 'szynka')
-- Znajdź funkcje i bandy które pełnią koty z wrogami o największym stopniu wrogości

select pseudo_kota, imie from incydenty 
where imie in 
(select imie from wrogowie
group by wrogowie.imie 
having stopien_wrogosci = max(wrogowie.stopien_wrogosci));

-- Znajdź kota który złapał najwięcej myszy i jego przydział myszy
select koty.pseudo, koty.przydzial from koty 
where koty.pseudo in 
(
SELECT pseudo_lapacza, COUNT(*) FROM myszy 
group by pseudo_lapacza);

-- Tygrys w celach przyszłej rekrutacji/stworzenia kursu musi sprawdzić czy nie brakuje jakiegoś zawodu w populacji
SELECT nazwa_funkcji, count(*) FROM koty GROUP BY nazwa_funkcji;
-- Przywodcy band powinni być znani kazdemu z kotów, ponieważ są bardzo ważni
SELECT pseudo FROM koty WHERE nazwa_funkcji = 'przywodca';
-- W celu wypłaty Tygrys musi sprawdzić ilość myszy na stanie 
SELECT count(*) FROM myszy WHERE pseudo_zjadacza IS NULL;

-- QUERIES WITH JOIN
-- W kocim świecie każdy z kotów powinien polować jedynie na polu swojej bandy
-- Zapytanie pozwoli stwierdzić czy jakiś kot nie jest na nie swoim terenie
SELECT koty.pseudo, bandy.teren FROM koty JOIN bandy ON koty.nr_bandy = bandy.nr_bandy
ORDER BY bandy.teren;

-- Koty potrzebują różnych łapówek aby przekupić wrogów
-- Aby ułatwić pomaganie w zbieraniu łapówek kotom przez inne koty 
-- Potrzebna jest lista łapówek dla kota, jeśli oczywiście ich potrzebuje lub ma możliwość przekupstwa
SELECT incydenty.pseudo_kota, lapowki_wrogow.lapowka FROM incydenty JOIN lapowki_wrogow USING(imie);

-- Tygrys w celu wypłaty potrzebuje listy kotów i ich minimalnych oraz maxymalnych wynagrodzeń
SELECT koty.pseudo, funkcje.min_myszy, funkcje.max_myszy FROM koty JOIN funkcje ON koty.nazwa_funkcji = funkcje.nazwa_funkcji;

-- W celu posprzątanie magazynu w którym są łapówki koty muszą wiedzieć których łapówek można się pozbyć
-- czyli takich które nie są brane przez któregokolwiek z kotów
SELECT lapowka FROM lapowki LEFT JOIN lapowki_wrogow USING(lapowka)
WHERE imie IS NULL;


-- Medycy pełnią kluczową rolę w stadzie więc Tygrys zarządził aby w każdym ze stad powinnien być medyk
-- Zapytanie pozwoli mu sprawdzić w których grupach nie ma medyków
SELECT bandy.nazwa FROM bandy
MINUS
SELECT bandy.nazwa FROM bandy JOIN koty USING(nr_bandy)
WHERE koty.nazwa_funkcji = 'medyk'
GROUP BY bandy.nazwa;

-- ZAPYTANIA Z PODZAPYTANIAMI

-- Wrogowie po alkoholu stają się bardzo natarczywi i agresywni
-- Tygrys postanowił zakazć przekazywania łapówek alkoholowych wrogom
-- Zapytanie zwróci listę kotów którzy mogą być podejrzani o szmuglowanie alkoholu wrogom
-- w celu odniesienia korzyści
SELECT incydenty.pseudo_kota
FROM incydenty
WHERE incydenty.imie IN
(SELECT lapowki_wrogow.imie 
FROM lapowki_wrogow
WHERE lapowki_wrogow.lapowka = 'piwo');

-- Kot których wrogowie mają największy poziom stopnia_wrogości są w dużym niebezpieczeństwie
-- Tygrys aby objąć takie koty kocim Programem Ochrony Świadków
-- potrzebuje listy najbardziej zagrożonych kotów
SELECT pseudo_kota FROM incydenty
WHERE incydenty.imie IN (
SELECT wrogowie.imie FROM wrogowie
where wrogowie.STOPIEN_WROGOSCI = 
(SELECT MAX(wrogowie.STOPIEN_WROGOSCI) FROM wrogowie));

-- Tygrys uruchomił program wsparcia dla wyjątkowo uzdolnionych kotów
-- decyzja o przyjęciu do programu jest wydawana na podstawie:
-- * aktualnego przydziału myszy
-- * kot musi być najlepszym łowcą (złapać najwięcej myszy)
-- Zapytanie pozwoli Tygrysowi wytypować kandydatów.
SELECT koty.pseudo, koty.przydzial_myszy from koty
where pseudo in 
(SELECT pseudo_lapacza FROM myszy 
group by pseudo_lapacza
having count(*) = (SELECT MAX(COUNT(*)) FROM myszy 
group by pseudo_lapacza));
