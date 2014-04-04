
/***************************************************************************
 *   Copyright (C) 2013 by antonio vergari                                 *
 *   arranger1044@aim.com                                                  *
 *                                                                         *
 *   Department of Computer Science                                        *
 *   University of Bari, Italy                                             *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/
 
public class Grid2D
{
  private static final float MIN_FLT_CMP = 0.5;
  protected PVector[][] points;
  protected PVector origin;
  protected float cellWidth;
  protected float cellHeight;
  protected int colPoints;
  protected int rowPoints;
  
  
  /* Constructors **********************************************************/

  public Grid2D()
  {
    cellWidth = 0;
    cellHeight = 0;
    colPoints = 0;
    rowPoints = 0;
  }
  
  public Grid2D(PVector origin, int cols, int rows, float cellWidth)
  {
    this(origin, cols, rows, cellWidth, cellWidth);
  }
  
  public Grid2D(PVector origin, 
                int cols, int rows, 
                float cellWidth, float cellHeight)
  {
    this.origin = origin;
    this.colPoints = cols + 1;
    this.rowPoints = rows + 1;
    this.cellWidth = cellWidth;
    this.cellHeight = cellHeight;
    this.points = new PVector[this.rowPoints][this.colPoints];
    this.points = initGridPoints(this.points);
  }
  
  
  /* Accessors **************************************************************/
  
  PVector getOrigin()
  {
    return this.origin;
  }

  PVector getPoint(int x, int y)
  {
    return this.points[x][y];
  }
  
  // PVector [][] getPoints()
  // {
  //   return this.points;
  // }
  
  float getCellWidth()
  {
    return this.cellWidth;
  }
  
  float getCellHeight()
  {
    return this.cellHeight;
  }
  
  int getColumns()
  {
    return this.colPoints - 1;
  }
  
  int getRows()
  {
    return this.rowPoints - 1;
  }
  
  int getColumnPoints()
  {
    return this.colPoints;
  }
  
  int getRowPoints()
  {
    return this.rowPoints;
  }
  
  void setCellHeight(float newHeight)
  {
    float diff = newHeight - this.cellHeight;
    this.points = stretchGridPoints(this.points, 0, diff);
    this.cellHeight = newHeight;
  }
  
  void setCellWidth(float newWidth)
  {
    float diff = newWidth - this.cellWidth;
    this.points = stretchGridPoints(this.points, diff, 0);
    this.cellWidth = newWidth;
  }

  void setRows(int rows)
  {
    if (rowPoints > 0)
    {
      this.rowPoints = rows + 1;
      PVector [][] newPoints = new PVector [this.rowPoints][this.colPoints];
      this.points = initGridPoints(newPoints);
    }
  }
  
  void setColumns(int cols)
  {
    if (colPoints > 0)
    {
      this.colPoints = cols + 1;
      PVector [][] newPoints = new PVector [this.rowPoints][this.colPoints];
      this.points = initGridPoints(newPoints);
    }
  }

  /* Modifying the grid *****************************************************/
  
  PVector [][] initGridPoints(PVector [][] points)
  {
    float xStart = this.origin.x;
    float yStart = this.origin.y;
    float xPos = 0;
    float yPos = 0;
    
    for(int i = 0; i < this.rowPoints; ++i)
    {
      yPos = yStart + i * this.cellHeight;
      for(int j = 0; j < this.colPoints; ++j)
      {
        xPos = xStart + j * this.cellWidth;
        points[i][j] = new PVector(xPos, yPos);
      } 
    }
    return points;
  }
  
  
  PVector [][] stretchGridPoints(PVector [][] points, 
                                 float xOffset, 
                                 float yOffset)
  { 
    for(int i = 0; i < this.rowPoints; ++i)
    {
      for(int j = 0; j < this.colPoints; ++j)
      {
        PVector point = points[i][j];
        point.x += j * xOffset;
        point.y += i * yOffset; 
      }
    }
    
    return points;
  }
  
  
  /* Drawing ***************************************************************/
  
  void draw(PGraphics pg)
  {
    /* Drawing row lines */
    for(int i = 0; i < this.rowPoints; ++i)
    {
      PVector startingPoint = this.points[i][0];
      PVector endingPoint = this.points[i][this.colPoints - 1];
      pg.line(startingPoint.x, startingPoint.y, endingPoint.x, endingPoint.y);
    }
    
    /* Drawing col lines */
    for(int j = 0; j < this.colPoints; ++j)
    {
      PVector startingPoint = this.points[0][j];
      PVector endingPoint = this.points[this.rowPoints - 1][j];
      pg.line(startingPoint.x, startingPoint.y, endingPoint.x, endingPoint.y);
    }
  }
  
  void draw(PGraphics pg, color c)
  {
    pg.stroke(c);
    draw(pg);
  }

  private int getRowIndex(float y, int start, int end)
  {
    // println("row", y, start, end);
    int i = -1;
    float startY = points[start][0].y;
    if(y - startY < cellHeight)
    {
      i = start;
    }
    else
    {
      int middle = start + floor((end - start) / 2);
      float middleY = points[middle][0].y;
      // println("middle", middle, middleY);
      if(y > middleY)
      {
        if(y - middleY < cellHeight)
        {
          i = middle;
        }
        else
        {
          i = getRowIndex(y, middle, end);
        }
      }
      else if(y < middleY)
      {
        i = getRowIndex(y, start, middle);
      }
    }
    return i;
  }

  private int getColumnIndex(float x, int start, int end)
  {
    int i = -1;
    // println("col", x, start, end);
    float startX = points[0][start].x;
    if(x - startX < cellWidth)
    {
      i = start;
    }
    else
    {
      int middle = start + floor((end - start) / 2);
      float middleX = points[0][middle].x;
      // println("middle", middle, middleX);
      if(x > middleX)
      {
        if(x - middleX < cellWidth)
        {
          i = middle;
        }
        else
        {
          i = getColumnIndex(x, middle, end);
        }
      }
      else if(x < middleX)
      {
        i = getColumnIndex(x, start, middle);
      }
    }

    return i;
  }
  
  public PVector getPointForCoordinates(PVector point)
  {
    PVector gridPoint = null;

    /* assuming the grid is instantiated */
    float x = point.x;
    float y = point.y;

    /* is the point inside the grid? */
    float startX = points[0][0].x;
    float startY = points[0][0].y;
    float endX = points[rowPoints- 1][colPoints -1].x;
    float endY = points[rowPoints- 1][colPoints -1].y;

    if(x >= startX && x <= endX
       &&
       y >= startY && y < endY)

    {
      /* binary search */
      int i = getRowIndex(y, 0, rowPoints);
      int j = getColumnIndex(x, 0, colPoints);
      if(i != -1 && j != -1)
      {
        gridPoint = new PVector(i, j);
      }
    }
    
    return gridPoint;
  }
}
