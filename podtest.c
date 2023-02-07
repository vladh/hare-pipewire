#include <math.h>
#include <stdio.h>

#include <spa/param/audio/format-utils.h>

#include <pipewire/pipewire.h>

int main(int argc, char *argv[])
{
        uint8_t buffer[1024];
        const struct spa_pod *params[1];
        struct spa_pod_builder b = SPA_POD_BUILDER_INIT(buffer, sizeof(buffer));
        params[0] = spa_format_audio_raw_build(&b, SPA_PARAM_EnumFormat,
                        &SPA_AUDIO_INFO_RAW_INIT(
                                .format = SPA_AUDIO_FORMAT_S16,
                                .channels = 69,
                                .rate = 420 ));
        return 0;
}
