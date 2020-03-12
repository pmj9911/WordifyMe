from django.contrib import admin

# Register your models here.
from .models import Profile , WordDetail
admin.site.register(Profile)
admin.site.register(WordDetail)
