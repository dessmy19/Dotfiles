#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <string.h>
#include <time.h>

static long read_int(const char *path) {
	FILE *f = fopen(path, "r");
	long v = -1;
	if (f) {
		if (fscanf(f, "%ld", &v) != 1)
			v = -1;
		fclose(f);
	}
	return v;
}

static void read_str(const char *path, char *buf, size_t n) {
	FILE *f = fopen(path, "r");
	buf[0] = '\0';
	if (f) {
		if (fgets(buf, n, f))
			buf[strcspn(buf, "\n")] = '\0';
		fclose(f);
	}
}

int main(void) {
	setvbuf(stdout, NULL, _IOLBF, 0);

	for (;;) {
		long b = read_int("/sys/class/power_supply/BAT0/capacity");
		char raw[32], s[8], tbuf[64];
		int sc, pc;
		time_t now;

		read_str("/sys/class/power_supply/BAT0/status", raw, sizeof raw);

		if (!strcmp(raw, "Charging"))          { strcpy(s, "Chg");  sc = 32; }
		else if (!strcmp(raw, "Full"))         { strcpy(s, "Full"); sc = 32; }
		else if (!strcmp(raw, "Discharging"))  { strcpy(s, "Dis");  sc = 33; }
		else if (!strcmp(raw, "Not charging")) { strcpy(s, "Idle"); sc = 33; }
		else                                   { snprintf(s, sizeof s, "%s", raw[0] ? raw : "n/a"); sc = 33; }

		pc = 32;
		if (b >= 0 && b < 60) pc = 33;
		if (b >= 0 && b < 20) pc = 31;

		now = time(NULL);
		strftime(tbuf, sizeof tbuf, "%a, %b %e   %I:%M:%S %p", localtime(&now));

		printf("\033[37mBAT \033[%dm%ld%%\033[0m \033[%dm(%s)\033[0m\033[37m   %s   \033[0m\n",
		       pc, b, sc, s, tbuf);

		struct timespec ts = { .tv_sec = 1, .tv_nsec = 0 };
		nanosleep(&ts, NULL);
	}
}
