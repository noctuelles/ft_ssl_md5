/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: plouvel <plouvel@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/07/02 14:52:05 by plouvel           #+#    #+#             */
/*   Updated: 2024/07/08 16:12:05 by plouvel          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "ft_ssl.h"
#include "includes/md5.h"
#include "libft.h"
#include "opts.h"

extern const char *program_invocation_short_name;

static const t_command g_available_cmds[] = {
    {.name                = "md5",
     .opts_parsing_config = &g_md5_opts_config,
     .hash_fd             = md5_fd,
     .hash_str            = md5_str},
    {.name                = "sha256",
     .opts_parsing_config = NULL,
     .hash_fd             = NULL,
     .hash_str            = NULL}};

static int
print_usage(int ret_code) {
    printf("usage: %s [COMMAND] [COMMAND OPTS] [FILE/STRING] \n\n",
           program_invocation_short_name);
    printf("Available commands :\n");
    for (size_t i = 0; i < NSIZE(g_available_cmds); i++) {
        printf("%s\n", g_available_cmds[i].name);
        if (g_available_cmds[i].opts_parsing_config == NULL) {
            continue;
        }
        printf("Available options :\n");
        ft_args_parser_print_docs(g_available_cmds[i].opts_parsing_config);
    }
    return (ret_code);
}

static void
print_digest(const uint8_t *digest, size_t ldigest) {
    size_t i = 0;

    while (i < ldigest) {
        printf("%02x", digest[i]);
        i++;
    }
    printf("\n");
}

static int
digest_msg(const t_command *cmd) {
    void  *digest  = NULL;
    size_t ldigest = 0;

    assert(cmd->hash_fd != NULL && "FD hash not implemented");
    assert(cmd->hash_str != NULL && "STR hash not implemented");

    cmd->hash_fd(STDIN, &digest, &ldigest);

    print_digest(digest, ldigest);

    return (0);
}

int
main(int argc, char **argv) {
    const char      *cmd_str = NULL;
    const t_command *cmd     = NULL;

    if (argc < 2) {
        return (print_usage(1));
    }
    cmd_str = argv[1];
    for (size_t i = 0; i < NSIZE(g_available_cmds); i++) {
        if (strcmp(cmd_str, g_available_cmds[i].name) == 0) {
            cmd = &g_available_cmds[i];
            break;
        }
    }
    if (cmd == NULL) {
        ft_error(0, 0, "'%s': no such command", cmd_str);
        return (1);
    }
    cmd->opts_parsing_config->argc = argc - 2;
    cmd->opts_parsing_config->argv = argv + 2;
    return (digest_msg(cmd));
}