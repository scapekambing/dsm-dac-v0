class comb:
	def __init__(self, stages):
		self.x_n  = 0
		self.stages = stages
	
	def update(self, inp):
		self.xnm = self.xn
		self.xn  = inp
		return (self.xn - self.xnm)