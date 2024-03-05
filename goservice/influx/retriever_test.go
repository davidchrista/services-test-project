package influx

import "testing"

func TestEmptyQuery(t *testing.T) {
	q := query([]string{})
	if q != `SELECT *
FROM "measurement"
WHERE
time >= now() - interval '3 minutes'` {
		t.Error("wrong query for empty selection")
	}
}

func TestSingleSelectionQuery(t *testing.T) {
	q := query([]string{"test"})
	if q != `SELECT *
FROM "measurement"
WHERE
time >= now() - interval '3 minutes'
AND
"sender" IN ('test')` {
		t.Error("wrong query for single selection")
	}
}

func TestMultiSelectionQuery(t *testing.T) {
	q := query([]string{"test", "test2"})
	if q != `SELECT *
FROM "measurement"
WHERE
time >= now() - interval '3 minutes'
AND
"sender" IN ('test', 'test2')` {
		t.Error("wrong query for multi selection")
	}
}
