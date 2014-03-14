
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
  protected PVector[][] points;
  protected PVector origin;
  protected float cellWidth;
  protected float cellHeight;
  protected int colPoints;
  protected int rowPoints;
  
  
  /* Constructors **********************************************************/
  
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
  
  PVector [][] getPoints()
  {
    return this.points;
  }
  
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
    this.rowPoints = rows + 1;
    PVector [][] newPoints = new PVector [this.rowPoints][this.colPoints];
    this.points = initGridPoints(newPoints);
  }
  
  void setColumns(int cols)
  {
    this.colPoints = cols + 1;
    PVector [][] newPoints = new PVector [this.rowPoints][this.colPoints];
    this.points = initGridPoints(newPoints);
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
}
