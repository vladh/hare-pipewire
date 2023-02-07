#include <math.h>
#include <stdio.h>

#include <spa/param/audio/format-utils.h>

#include <pipewire/pipewire.h>

int main(int argc, char *argv[])
{
        uint8_t buffer[1024];
        struct spa_pod_builder b = SPA_POD_BUILDER_INIT(buffer, sizeof(buffer));

        /* pod = spa_format_audio_raw_build(&b, SPA_PARAM_EnumFormat, */
        /*                 &SPA_AUDIO_INFO_RAW_INIT( */
        /*                         .format = SPA_AUDIO_FORMAT_S16, */
        /*                         .channels = 69, */
        /*                         .rate = 420 )); */
        struct spa_pod_frame f;
        spa_pod_builder_push_object(&b, &f, SPA_TYPE_OBJECT_Format,
                SPA_PARAM_EnumFormat);
        spa_pod_builder_prop(&b, SPA_FORMAT_AUDIO_format, 0);
        spa_pod_builder_id(&b, SPA_AUDIO_FORMAT_S16);
        struct spa_pod *pod = spa_pod_builder_pop(&b, &f);

        uint32_t *p = (uint32_t *)pod;
        for (int i = 0; i < ((*p) / 4) + 2; i++) {
                printf("%02d ", p[i]);
        }
        printf("\n");

        return 0;
}
