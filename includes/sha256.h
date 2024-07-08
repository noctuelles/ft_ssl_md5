/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   sha256.h                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: plouvel <plouvel@student.42.fr>            +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/07/08 16:23:46 by plouvel           #+#    #+#             */
/*   Updated: 2024/07/08 18:16:53 by plouvel          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef SHA256_H
#define SHA256_H

#include <stddef.h>
#include <stdint.h>

#include "utils.h"

typedef struct s_sha256_ctx {
    uint8_t  buffer[64];
    uint32_t state[8];
} t_sha256_ctx;

/**
 * @brief  SHA-224 and SHA-256 logicial functions. Each function operate on
 * 32-bit words.
 */

#define CH(X, Y, Z) (((X) & (Y)) ^ (~(X) & (Z)))
#define MAJ(X, Y, Z) (((X) & (Y)) ^ ((X) & (Z)) ^ ((Y) & (Z)))

#define SSIG0(X) (R_ROT_32(X, 7) ^ R_ROT_32(X, 18) ^ ((X) >> 3))
#define SSIG1(X) (R_ROT_32(X, 17) ^ R_ROT_32(X, 19) ^ ((X) >> 10))
#define BSIG0(X) (R_ROT_32(X, 2) ^ R_ROT_32(X, 13) ^ R_ROT_32(X, 22))
#define BSIG1(X) (R_ROT_32(X, 6) ^ R_ROT_32(X, 11) ^ R_ROT_32(X, 25))

#endif