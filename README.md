# Hare pipewire Bindings

Dependencies:

* [hare-spapod](https://git.sr.ht/~vladh/hare-spapod)

Dependencies for demo:

* [hare-wav](https://git.sr.ht/~vladh/hare-wav)

## Vendoring

```
git subtree -P vendor/hare-pipewire/ add https://git.sr.ht/~vladh/hare-pipewire main
```

## Test

There is a .wav file test you can run with `make run`. Put a `test.wav` file in the root directory to play it.

## Contributing

Send patches to `~vladh/general@lists.sr.ht` using subject prefix `[PATCH hare-pipewire]`. For example:

```
git config sendemail.to '~vladh/general@lists.sr.ht'
git config format.subjectPrefix 'PATCH hare-pipewire'
git send-email HEAD^
```

For more information, see [git-send-email.io](https://git-send-email.io/).
