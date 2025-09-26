Locales = Locales or {}

-- Helper to determine current lang
local function getLang()
  if Config.Locale and Config.Locale ~= 'auto' then
    return Config.Locale
  end
  if lib and lib.getLocale then
    local L = lib.getLocale()
    if type(L) == 'string' and #L > 0 then return L end
  end
  return 'en'
end

-- Fetch string by key with optional args
function _L(key, ...)
  local lang = getLang()
  local pack = Locales[lang] or Locales.en
  local val = pack[key]

  -- functions (dynamic strings) or constants
  if type(val) == 'function' then return val(...) end
  if val ~= nil then return val end

  -- fallback to en, then key
  local def = Locales.en[key]
  if type(def) == 'function' then return def(...) end
  return def or key
end

-- ========== ENGLISH ==========
Locales.en = {
  title_menu         = 'Vehicle Keys Manager',
  title_remove_all   = 'Remove ALL Keys',
  title_keep_closest = 'Keep Closest Vehicle Key',
  title_keep_current = 'Keep Current Vehicle Key',

  menu_desc_all = function(keyItem)
    return ('Deletes every "%s" in your inventory.'):format(keyItem or 'vehiclekeys')
  end,

  menu_desc_keep_closest = function(plate)
    return plate and ('Keeps plate: %s'):format(plate) or 'No nearby vehicle found.'
  end,

  menu_desc_keep_current = function(plate)
    return plate and ('Keeps plate: %s'):format(plate) or 'Not in a vehicle.'
  end,

  ntf_removed_all = function(count)
    return count > 0 and ('Removed %d key(s).'):format(count) or 'No keys to remove.'
  end,

  ntf_removed_except = function(count, keepPlate)
    if count <= 0 then return 'No keys removed. (Either none found or all matched the kept plate.)' end
    if keepPlate and keepPlate ~= '' then
      return ('Removed %d key(s). Kept plate: %s.'):format(count, keepPlate)
    end
    return ('Removed %d key(s).'):format(count)
  end,

  error_ox_missing = 'ox_lib not found. Make sure it starts and @ox_lib/init.lua is in fxmanifest.'
}

-- ========== SPANISH ==========
Locales.es = {
  title_menu         = 'Administrador de Llaves de Vehículo',
  title_remove_all   = 'Eliminar TODAS las llaves',
  title_keep_closest = 'Conservar llave del vehículo más cercano',
  title_keep_current = 'Conservar llave del vehículo actual',

  menu_desc_all = function(keyItem)
    return ('Elimina todas las "%s" de tu inventario.'):format(keyItem or 'vehiclekeys')
  end,
  menu_desc_keep_closest = function(plate)
    return plate and ('Conserva matrícula: %s'):format(plate) or 'No se encontró vehículo cercano.'
  end,
  menu_desc_keep_current = function(plate)
    return plate and ('Conserva matrícula: %s'):format(plate) or 'No estás en un vehículo.'
  end,

  ntf_removed_all = function(count)
    return count > 0 and ('Se eliminaron %d llave(s).'):format(count) or 'No hay llaves para eliminar.'
  end,
  ntf_removed_except = function(count, keepPlate)
    if count <= 0 then return 'No se eliminaron llaves.' end
    if keepPlate and keepPlate ~= '' then
      return ('Se eliminaron %d llave(s). Matrícula conservada: %s.'):format(count, keepPlate)
    end
    return ('Se eliminaron %d llave(s).'):format(count)
  end,

  error_ox_missing = 'Falta ox_lib. Asegúrate de iniciarlo y de incluir @ox_lib/init.lua en fxmanifest.'
}

-- ========== GERMAN ==========
Locales.de = {
  title_menu='Fahrzeugschlüssel-Manager',
  title_remove_all='ALLE Schlüssel entfernen',
  title_keep_closest='Schlüssel des nächsten Fahrzeugs behalten',
  title_keep_current='Schlüssel des aktuellen Fahrzeugs behalten',
  menu_desc_all=function(keyItem) return ('Löscht alle „%s“ aus deinem Inventar.'):format(keyItem or 'vehiclekeys') end,
  menu_desc_keep_closest=function(p) return p and ('Behält Kennz.: %s'):format(p) or 'Kein Fahrzeug in der Nähe.' end,
  menu_desc_keep_current=function(p) return p and ('Behält Kennz.: %s'):format(p) or 'Nicht im Fahrzeug.' end,
  ntf_removed_all=function(c) return c>0 and ('%d Schlüssel entfernt.'):format(c) or 'Keine Schlüssel zu entfernen.' end,
  ntf_removed_except=function(c, keep) if c<=0 then return 'Keine Schlüssel entfernt.' end
    return keep and keep~='' and ('%d Schlüssel entfernt. Behalten: %s.'):format(c, keep) or ('%d Schlüssel entfernt.'):format(c) end,
  error_ox_missing='ox_lib fehlt. Starte es und füge @ox_lib/init.lua in fxmanifest ein.'
}

-- ========== FRENCH ==========
Locales.fr = {
  title_menu='Gestionnaire de clés de véhicule',
  title_remove_all='Supprimer TOUTES les clés',
  title_keep_closest='Garder la clé du véhicule le plus proche',
  title_keep_current='Garder la clé du véhicule actuel',
  menu_desc_all=function(k) return ('Supprime toutes les « %s » de votre inventaire.'):format(k or 'vehiclekeys') end,
  menu_desc_keep_closest=function(p) return p and ('Conserve plaque : %s'):format(p) or 'Aucun véhicule à proximité.' end,
  menu_desc_keep_current=function(p) return p and ('Conserve plaque : %s'):format(p) or 'Pas dans un véhicule.' end,
  ntf_removed_all=function(c) return c>0 and ('%d clé(s) supprimée(s).'):format(c) or 'Aucune clé à supprimer.' end,
  ntf_removed_except=function(c, keep) if c<=0 then return 'Aucune clé supprimée.' end
    return keep and keep~='' and ('%d clé(s) supprimée(s). Plaque conservée : %s.'):format(c, keep) or ('%d clé(s) supprimée(s).'):format(c) end,
  error_ox_missing="ox_lib introuvable. Assurez-vous qu'il démarre et que @ox_lib/init.lua est dans fxmanifest."
}

-- ========== ITALIAN ==========
Locales.it = {
  title_menu='Gestore Chiavi Veicolo',
  title_remove_all='Rimuovi TUTTE le chiavi',
  title_keep_closest='Tieni chiave del veicolo più vicino',
  title_keep_current='Tieni chiave del veicolo attuale',
  menu_desc_all=function(k) return ('Elimina tutte le "%s" dall\'inventario.'):format(k or 'vehiclekeys') end,
  menu_desc_keep_closest=function(p) return p and ('Tieni targa: %s'):format(p) or 'Nessun veicolo vicino.' end,
  menu_desc_keep_current=function(p) return p and ('Tieni targa: %s'):format(p) or 'Non sei in un veicolo.' end,
  ntf_removed_all=function(c) return c>0 and ('Rimosse %d chiave/i.'):format(c) or 'Nessuna chiave da rimuovere.' end,
  ntf_removed_except=function(c, keep) if c<=0 then return 'Nessuna chiave rimossa.' end
    return keep and keep~='' and ('Rimosse %d chiave/i. Targa tenuta: %s.'):format(c, keep) or ('Rimosse %d chiave/i.'):format(c) end,
  error_ox_missing='ox_lib non trovato. Avviarlo e includere @ox_lib/init.lua nel fxmanifest.'
}

-- ========== PORTUGUESE (BR) ==========
Locales.pt = {
  title_menu='Gerenciador de Chaves do Veículo',
  title_remove_all='Remover TODAS as chaves',
  title_keep_closest='Manter chave do veículo mais próximo',
  title_keep_current='Manter chave do veículo atual',
  menu_desc_all=function(k) return ('Remove todas as "%s" do seu inventário.'):format(k or 'vehiclekeys') end,
  menu_desc_keep_closest=function(p) return p and ('Mantém placa: %s'):format(p) or 'Nenhum veículo próximo.' end,
  menu_desc_keep_current=function(p) return p and ('Mantém placa: %s'):format(p) or 'Você não está em um veículo.' end,
  ntf_removed_all=function(c) return c>0 and ('Removida(s) %d chave(s).'):format(c) or 'Nenhuma chave para remover.' end,
  ntf_removed_except=function(c, keep) if c<=0 then return 'Nenhuma chave removida.' end
    return keep and keep~='' and ('Removida(s) %d chave(s). Placa mantida: %s.'):format(c, keep) or ('Removida(s) %d chave(s).'):format(c) end,
  error_ox_missing='ox_lib não encontrada. Certifique-se de iniciá-la e incluir @ox_lib/init.lua no fxmanifest.'
}

-- ========== TURKISH ==========
Locales.tr = {
  title_menu='Araç Anahtarı Yöneticisi',
  title_remove_all='TÜM anahtarları sil',
  title_keep_closest='En yakındaki aracın anahtarını tut',
  title_keep_current='Mevcut aracın anahtarını tut',
  menu_desc_all=function(k) return ('Envanterindeki tüm "%s" silinir.'):format(k or 'vehiclekeys') end,
  menu_desc_keep_closest=function(p) return p and ('Plaka korunur: %s'):format(p) or 'Yakında araç yok.' end,
  menu_desc_keep_current=function(p) return p and ('Plaka korunur: %s'):format(p) or 'Bir araçta değilsin.' end,
  ntf_removed_all=function(c) return c>0 and ('%d anahtar silindi.'):format(c) or 'Silinecek anahtar yok.' end,
  ntf_removed_except=function(c, keep) if c<=0 then return 'Anahtar silinmedi.' end
    return keep and keep~='' and ('%d anahtar silindi. Korunan plaka: %s.'):format(c, keep) or ('%d anahtar silindi.'):format(c) end,
  error_ox_missing='ox_lib bulunamadı. Başlatıldığından ve fxmanifest\'te @ox_lib/init.lua olduğundan emin olun.'
}

-- ========== RUSSIAN ==========
Locales.ru = {
  title_menu='Менеджер ключей от авто',
  title_remove_all='Удалить ВСЕ ключи',
  title_keep_closest='Оставить ключ ближайшего авто',
  title_keep_current='Оставить ключ текущего авто',
  menu_desc_all=function(k) return ('Удаляет все «%s» из инвентаря.'):format(k or 'vehiclekeys') end,
  menu_desc_keep_closest=function(p) return p and ('Сохр. номер: %s'):format(p) or 'Рядом нет автомобиля.' end,
  menu_desc_keep_current=function(p) return p and ('Сохр. номер: %s'):format(p) or 'Вы не в авто.' end,
  ntf_removed_all=function(c) return c>0 and ('Удалено ключей: %d.'):format(c) or 'Нет ключей для удаления.' end,
  ntf_removed_except=function(c, keep) if c<=0 then return 'Ключи не удалены.' end
    return keep and keep~='' and ('Удалено ключей: %d. Сохранён номер: %s.'):format(c, keep) or ('Удалено ключей: %d.'):format(c) end,
  error_ox_missing='Не найден ox_lib. Запустите его и добавьте @ox_lib/init.lua в fxmanifest.'
}

-- ========== ARABIC ==========
Locales.ar = {
  title_menu='مدير مفاتيح المركبات',
  title_remove_all='حذف جميع المفاتيح',
  title_keep_closest='الاحتفاظ بمفتاح أقرب مركبة',
  title_keep_current='الاحتفاظ بمفتاح المركبة الحالية',
  menu_desc_all=function(k) return ('يحذف جميع "%s" من مخزونك.'):format(k or 'vehiclekeys') end,
  menu_desc_keep_closest=function(p) return p and ('يحتفظ باللوحة: %s'):format(p) or 'لا توجد مركبة قريبة.' end,
  menu_desc_keep_current=function(p) return p and ('يحتفظ باللوحة: %s'):format(p) or 'لست داخل مركبة.' end,
  ntf_removed_all=function(c) return c>0 and ('تم حذف %d مفتاح(مفاتيح).'):format(c) or 'لا توجد مفاتيح لحذفها.' end,
  ntf_removed_except=function(c, keep) if c<=0 then return 'لم يتم حذف أي مفاتيح.' end
    return keep and keep~='' and ('تم حذف %d مفتاح(مفاتيح). تم الاحتفاظ باللوحة: %s.'):format(c, keep) or ('تم حذف %d مفتاح(مفاتيح).'):format(c) end,
  error_ox_missing='لم يتم العثور على ox_lib. تأكد من تشغيله وإضافة @ox_lib/init.lua إلى fxmanifest.'
}

-- ========== POLISH ==========
Locales.pl = {
  title_menu='Menedżer kluczy pojazdu',
  title_remove_all='Usuń WSZYSTKIE klucze',
  title_keep_closest='Zachowaj klucz najbliższego pojazdu',
  title_keep_current='Zachowaj klucz aktualnego pojazdu',
  menu_desc_all=function(k) return ('Usuwa wszystkie „%s” z ekwipunku.'):format(k or 'vehiclekeys') end,
  menu_desc_keep_closest=function(p) return p and ('Zachowuje tablicę: %s'):format(p) or 'Brak pojazdu w pobliżu.' end,
  menu_desc_keep_current=function(p) return p and ('Zachowuje tablicę: %s'):format(p) or 'Nie jesteś w pojeździe.' end,
  ntf_removed_all=function(c) return c>0 and ('Usunięto %d klucz(e).'):format(c) or 'Brak kluczy do usunięcia.' end,
  ntf_removed_except=function(c, keep) if c<=0 then return 'Nie usunięto kluczy.' end
    return keep and keep~='' and ('Usunięto %d klucz(e). Zachowano tablicę: %s.'):format(c, keep) or ('Usunięto %d klucz(e).'):format(c) end,
  error_ox_missing='Brak ox_lib. Uruchom i dodaj @ox_lib/init.lua do fxmanifest.'
}

-- ========== DUTCH ==========
Locales.nl = {
  title_menu='Voertuigsleutelbeheer',
  title_remove_all='ALLE sleutels verwijderen',
  title_keep_closest='Sleutel dichtstbijzijnde voertuig behouden',
  title_keep_current='Sleutel huidige voertuig behouden',
  menu_desc_all=function(k) return ('Verwijdert alle "%s" uit je inventaris.'):format(k or 'vehiclekeys') end,
  menu_desc_keep_closest=function(p) return p and ('Behouden kenteken: %s'):format(p) or 'Geen voertuig dichtbij.' end,
  menu_desc_keep_current=function(p) return p and ('Behouden kenteken: %s'):format(p) or 'Niet in een voertuig.' end,
  ntf_removed_all=function(c) return c>0 and ('%d sleutel(s) verwijderd.'):format(c) or 'Geen sleutels om te verwijderen.' end,
  ntf_removed_except=function(c, keep) if c<=0 then return 'Geen sleutels verwijderd.' end
    return keep and keep~='' and ('%d sleutel(s) verwijderd. Behouden kenteken: %s.'):format(c, keep) or ('%d sleutel(s) verwijderd.'):format(c) end,
  error_ox_missing='ox_lib niet gevonden. Start het en voeg @ox_lib/init.lua toe aan fxmanifest.'
}
