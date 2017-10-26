#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <fcntl.h>
#include <errno.h>

#define BUF_SIZE 5000
#define BUF_LEN 4096

static inline double millitime(){
    struct timeval now;
    gettimeofday(&now, NULL);
    double ret = now.tv_sec + now.tv_usec/1000.0/1000.0;
    return ret;
}
int main(int argc, char* argv[])
{
    int ret;
    int fd = open(argv[1], O_WRONLY | O_CREAT);
    if (fd == -1)
    {
        printf("please input a file to write to, e.g. './tmp.txt'\n");
        perror("open");
        abort();
    }
    char buf[BUF_SIZE] = "";
    int len = BUF_LEN;
    for (int i = 0; i < len; i++)
        buf[i] = '+';
    double stime = millitime();
    long tot = 0;
    while (1)
    {
        ret = write(fd, buf, len);
        if (ret != len)
        {
            perror("write");
            abort();
        }
        tot += ret;
        ret = fsync(fd);
        if (ret != 0)
        {
            perror("fsync");
            abort();
        }
        if (tot % (1024 * 1024) == 0)
        {
            double time_cost = millitime() - stime;
            double tput = tot / 1024 / 1024 / time_cost; 
            printf("\rThroughput (MB/s): %.6f", tput);
            fflush(stdout);
        }
    }
    return 0;
}
