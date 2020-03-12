from django.db import models
import datetime
class Profile(models.Model):
    name = models.CharField(max_length=100,default=None)

class WordDetail(models.Model):
	word = models.CharField(max_length=100,default=None)
	meaning = models.CharField(max_length=1000, default=None)
	dateEntered = models.DateField(default=None)

	def __str__(self):
			return str(self.word)