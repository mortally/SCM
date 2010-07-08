/**
 * SICS ISL Java Utilities
 * http://www.sics.se/tac/    tac-dev@sics.se
 *
 * Copyright (c) 2001-2003 SICS AB. All rights reserved.
 *
 * SICS grants you the right to use, modify, and redistribute this
 * software for noncommercial purposes, on the conditions that you:
 * (1) retain the original headers, including the copyright notice and
 * this text, (2) clearly document the difference between any derived
 * software and the original, and (3) acknowledge your use of this
 * software in pertaining publications and reports.  SICS provides
 * this software "as is", without any warranty of any kind.  IN NO
 * EVENT SHALL SICS BE LIABLE FOR ANY DIRECT, SPECIAL OR INDIRECT,
 * PUNITIVE, INCIDENTAL OR CONSEQUENTIAL LOSSES OR DAMAGES ARISING OUT
 * OF THE USE OF THE SOFTWARE.
 *
 * -----------------------------------------------------------------
 *
 * PositiveRangeDiagram
 *
 * Author  : Joakim Eriksson, Niclas Finne, Sverker Janson
 * Created : Sun Feb 02 13:15:02 2003
 * Updated : $Date: 2003/06/24 16:18:50 $
 *           $Revision: 1.7 $
 */

package se.sics.tasim.visualizer.gui;
import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Component;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Insets;
import java.awt.Rectangle;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.geom.Line2D;
import java.awt.image.BufferedImage;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import se.sics.isl.util.FormatUtils;

/**
 * A simple dot diagram based on the <code>PositiveBoundedRangeModel</code>
 * with support for several dot lines and any number of constant lines.
 * It's x-axis runns from 0 to the last day value of the
 * <code>PositiveBoundedRangeModel</code>. It further displays a vertical
 * line indicating the current value of the
 * <code>PositiveBoundedRangeModel</code>.
 */
public class PositiveRangeDiagram extends JComponent {
  private static final double PADDING = 0.1;
  private static final BasicStroke defaultStroke = new BasicStroke(1.0f);
  private static final BasicStroke wideStroke = new BasicStroke(8.0f);
  private BufferedImage  buffImg;
    private Line2D.Double slider;

    // The data "vector" - any number of vectors
    private int[][] data;
    private int[] maxData;
    private int[] minData;
    private int totMax;
    private int totMin;

    private int[] step;
    private String title;
    private Border border;
    private String titleUnit;
    private int titleDiag;

    private boolean lockMinMax = false;
    private double scaleFactor;

    private int[] constantY;
    private Color[] constantColor;

    private Color[] lineColor;

    private boolean[] visible;
    private boolean[] emphasized;

    private boolean rescale = false;

    // Cache to avoid creating new insets objects for each repaint. Is
    // created when first needed.
    private Insets insets;

    private PositiveBoundedRangeModel dayModel;

    /**
     * Creates a new <code>PositiveRangeDiagram</code> instance.
     *
     * @param diagrams The maximum number of (non constant) diagrams to
     *                 support.
     * @param dm The <code>PositiveBoundedRangeModel</code> instance to use.
     */
    public PositiveRangeDiagram(int diagrams, PositiveBoundedRangeModel dm) {
	super();
	data = new int[diagrams][];
	lineColor = new Color[diagrams];
	step = new int[diagrams];
	maxData = new int[diagrams];
	minData = new int[diagrams];
	visible = new boolean[diagrams];
	emphasized = new boolean[diagrams];

	for (int i = 0; i < diagrams; i++) {
	    lineColor[i] = Color.black;
	}

	dayModel = dm;

	// Repaint when datamodel changes
	if(dayModel != null) {
	    dayModel.addChangeListener(new ChangeListener() {
		    public void stateChanged(ChangeEvent ce) {
			repaint();
		    }
		});
	}

	addComponentListener(new ComponentAdapter() {
	    public void componentResized(ComponentEvent ce) {
	      rescale = true;
	    }
	  });

	setOpaque(true);
    }

    public void setTitle(int diag, String title, String unit) {
	titleDiag = diag;
	this.title = title;
	titleUnit = unit;
	repaint();
    }

    /**
     * <code>addConstant</code> will add a horizontal line to the diagram
     *
     * @param color to use for the line - a <code>Color</code> value
     * @param y value of constant - an <code>int</code> value
     */
    public void addConstant(Color color, int y) {
	int index;
	if (constantY == null) {
	    index = 0;
	    constantY = new int[1];
	    constantColor = new Color[1];
	} else {
	    index = constantY.length;
	    int[] tmpY = new int[index + 1];
	    Color[] tmpC = new Color[index + 1];
	    for (int i = 0; i < index; i++) {
		tmpY[i] = constantY[i];
		tmpC[i] = constantColor[i];
	    }
	    constantY = tmpY;
	    constantColor = tmpC;
	}
	constantY[index] = y;
	constantColor[index] = color == null ? Color.black : color;
	rescale = true;
	repaint();
    }

    /**
     * The <code>setMinMax</code> method fixes the maximum and minimum of
     * the y-axis to display. It prevents the diagram from rescaling to
     * fit the data.
     *
     * @param min an <code>int</code> value
     * @param max an <code>int</code> value
     */
    public void setMinMax(int min, int max) {
	totMax = max;
	totMin = min;
	lockMinMax = true;
    }

    /**
     * <code>setData</code> adds a new dataset to the diagram.
     *
     * @param diag Which dataset - an <code>int</code> value
     * @param data The values of the dataset - an <code>int[]</code>
     * @param step Interval between values - <code>int</code> value
     */
    public void setData(int diag, int[] data, int step) {
	int maxData = Integer.MIN_VALUE;
	int minData = Integer.MAX_VALUE;

	if(data == null) {
	    throw new NullPointerException();
	}

	if(data.length == 0 || step <= 0)
	    return;

	for (int i = 0, n = data.length; i < n; i++) {
	    if (maxData < data[i]) maxData = data[i];
	    if (minData > data[i]) minData = data[i];
	}
	if (minData > 0) {
	    minData = 0;
	}
	if (maxData < minData) {
	    maxData = minData;
	}


	this.data[diag] = data;
	this.step[diag] = step;
	this.maxData[diag] = maxData;
	this.minData[diag] = minData;
	this.visible[diag] = true;

	rescale = true;
	repaint();
    }

    /**
     * Sets the color of a datasets diagram
     *
     * @param diag The dataset - <code>int</code> value
     * @param color The color to use - a <code>Color</code> value
     */
    public void setDotColor(int diag, Color color) {
	if (color == null) {
	    throw new NullPointerException();
	}
	lineColor[diag] = color;

	repaint();

    }

    public void setVisible(int diag, boolean vis) {
	visible[diag] = vis;
    }

    public void setEmphasized(int diag, boolean emph) {
	emphasized[diag] = emph;
    }

    private void drawImg() {
	Graphics2D g2 = buffImg.createGraphics();
	g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
			    RenderingHints.VALUE_ANTIALIAS_ON);

    int width = buffImg.getWidth(null);
    int height = buffImg.getHeight(null);


    if (isOpaque()) {
      g2.setPaint(Color.white);
      g2.fill(new Rectangle(0, 0, width, height));
    }

    // Draw the constants
    if (constantY != null) {
      for (int i = 0, n = constantY.length; i < n; i++) {
	double cy = (height-height*PADDING*0.5) -
	  (scaleFactor * Math.abs(constantY[i] - totMin));
	g2.setPaint(constantColor[i]);
		g2.draw(new Line2D.Double(0, cy, width, cy));
      }
    }

    // Draw the data sets
    for (int j = 0, m = data.length; j < m; j++) {

      if (data[j] == null || visible[j] == false)
	continue;

      // Compute step length in real pixels
      double acctualStepLength = (double) step[j] *
	((double) width / (double) dayModel.getLast());

      g2.setPaint(lineColor[j]);

      double lastY = (height-height*PADDING*0.5) -
	(scaleFactor * Math.abs(data[j][0] - totMin));
      double lastX = 0;
      for (int i = 1, n = data[j].length; i < n; i++) {

	double y0 = (height-height*PADDING*0.5) -
		(scaleFactor * Math.abs(data[j][i] - totMin));
	double x0 = (i * acctualStepLength);

	if(emphasized[j])
		g2.setStroke(wideStroke);
	else
	  g2.setStroke(defaultStroke);


	g2.draw(new Line2D.Double(lastX, lastY, x0, y0));


	lastY = y0;
	lastX = x0;
      }

    } // Drawing data sets loop ends


  }

    public void update(Graphics g) {}

    protected void paintComponent(Graphics g) {
	//super.paintComponent(g);
      Graphics2D g2 = (Graphics2D) g;
      g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
			  RenderingHints.VALUE_ANTIALIAS_ON);

	Color oldColor = g.getColor();
	int totalWidth = getWidth();
	int totalHeight = getHeight();


	border = getBorder();
	if(border != null && title != null && titleUnit != null &&
	   data[titleDiag].length > dayModel.getCurrent() &&
	   border instanceof TitledBorder) {
	    ((TitledBorder)border).
		setTitle(" " + title +
			 FormatUtils.formatAmount(data[titleDiag][dayModel.getCurrent()]) +
			 titleUnit + " ");
	}


	insets = getInsets(insets);
	int x = insets.left;
	int y = insets.top;
	int width = totalWidth - insets.left - insets.right;
	int height = totalHeight - insets.top - insets.bottom;

	if(x > 0)
	    g2.clearRect(0, 0, x, totalHeight);
	if(y > 0)
	    g2.clearRect(0, 0, totalWidth, y);
	if(insets.right > 0)
	    g2.clearRect(x+width, 0, totalWidth, totalHeight);
	if(insets.bottom > 0)
	    g2.clearRect(0, y+height, totalWidth, totalHeight);


	// Create buffered image if needed
	if (buffImg == null) {
	    buffImg = new BufferedImage(width, height,
					BufferedImage.TYPE_INT_RGB);
	    drawImg();
	}

	if (buffImg.getHeight(null) != height ||
	    buffImg.getWidth(null) != width) {
	    buffImg = new BufferedImage(width, height,
					BufferedImage.TYPE_INT_RGB);

	    drawImg();
	}

	if(rescale) {
	    rescaleData(height);
	    rescale = false;
	    drawImg();
	}

	g2.drawImage(buffImg, null, x, y);

	// Draw the sliding time line
	double acctualStepLength =
	    (double) (width-1) / (double) dayModel.getLast();
	double sliderPosition = x+(dayModel.getCurrent()*acctualStepLength);

	if(slider == null)
	    slider = new Line2D.Double();
	slider.y1 = y;
	slider.y2 = y+height;
	slider.x1 = sliderPosition;
	slider.x2 = slider.x1;

	g2.setPaint(Color.magenta);
	g2.draw(slider);
	g2.setPaint(oldColor);
    }



    protected void rescaleData(int height) {
	// If min max limits for y-axis arn't locked, find them
	if(!lockMinMax) {
	    totMax = Integer.MIN_VALUE;
	    totMin = Integer.MAX_VALUE;

	    for (int i = 0, n = data.length; i < n; i++) {
		if (totMax < maxData[i]) totMax = maxData[i];
		if (totMin > minData[i]) totMin = minData[i];
	    }

		if (constantY != null) {
		    for (int i = 0, n = constantY.length; i < n; i++) {
			int cy = constantY[i];
			if (cy < totMin) totMin = cy;
			if (cy > totMax) totMax = cy;
		    }
		}

		if (totMin == Integer.MAX_VALUE) {
		    totMin = 0;
		    totMax = 0;
		}
	    }

	    // Compute new scale factor
	    if (totMax == totMin ) {
		scaleFactor = 1;
	    } else {
		scaleFactor = (double) (height - height*PADDING) /
		    (double) Math.abs(totMax - totMin);
	    }
    }
}
