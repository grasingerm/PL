#ifndef __LATTICE_H__
#define __LATTICE_H__

typedef enum
{
  BLT_ACTIVE,
  BLT_SUSPD,
  BLT_SOLID,
  BLT_ZOU_VEL,
  BLT_ZOU_PRS
} blt_node_type;

typedef struct
{
  double phi[3];
  int type;
} blt_node;

void stream(blt_node*, const unsigned int);
void collide(blt_node*, const unsigned int);

#endif